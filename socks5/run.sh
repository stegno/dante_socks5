#!/bin/bash

CONFIG_FILE="/etc/danted.conf"

# Генерация конфигурации danted.conf
echo "logoutput: stderr" > "$CONFIG_FILE"
echo "internal: 0.0.0.0 port=${PORT}" >> "$CONFIG_FILE"
echo "external: eth0" >> "$CONFIG_FILE"
echo "method: username" >> "$CONFIG_FILE"
echo "user.privileged: root" >> "$CONFIG_FILE"
echo "user.notprivileged: nobody" >> "$CONFIG_FILE"
echo "client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}" >> "$CONFIG_FILE"
echo "socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}" >> "$CONFIG_FILE"

# Создание пользователей
for user in $(jq -c '.users[]' /data/options.json); do
    username=$(echo "$user" | jq -r '.username')
    password=$(echo "$user" | jq -r '.password')
    adduser -D "$username"
    echo "${username}:${password}" | chpasswd
done

# Запуск сервера
exec danted -f "$CONFIG_FILE" -D
