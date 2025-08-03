#!/usr/bin/with-contenv bashio

set -e

CONFIG_PATH=/data/options.json
DANTED_CONF=/etc/danted.conf

PORT=$(bashio::config 'port')
USERS=$(bashio::config 'users')

# Validate users array
if [ -z "${USERS}" ] || [ "${USERS}" = "[]" ]; then
    bashio::log.error "No users defined in configuration!"
    exit 1
fi

# Create users
for row in $(echo "${USERS}" | jq -r '.[] | @base64'); do
    _jq() {
        echo "${row}" | base64 --decode | jq -r "${1}"
    }
    USERNAME=$(_jq '.username')
    PASSWORD=$(_jq '.password')

    if ! id "${USERNAME}" > /dev/null 2>&1; then
        useradd -M -s /usr/sbin/nologin "${USERNAME}"
    fi

    echo "${USERNAME}:${PASSWORD}" | chpasswd
done

# Generate Dante configuration
cat << EOF > ${DANTED_CONF}
logoutput: /dev/stdout
internal: 0.0.0.0 port = ${PORT}
external: eth0

method: username none
user.notprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    command: connect bind udpassociate
    log: connect disconnect error
    method: username
}
EOF

# Ensure service directory exists
mkdir -p /etc/services.d/danted

# Create s6-overlay service script
cat << EOF > /etc/services.d/danted/run
#!/usr/bin/with-contenv bashio
exec /usr/sbin/danted -f ${DANTED_CONF}
EOF

chmod +x /etc/services.d/danted/run

# Exit cleanly to let s6-overlay manage services
exit 0
