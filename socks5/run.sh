#!/bin/bash

set -e

# Создание пользователей
for user in $(jq -c '.users[]' /data/options.json); do
    USERNAME=$(echo "$user" | jq -r '.username')
    PASSWORD=$(echo "$user" | jq -r '.password')
    
    if ! id "$USERNAME" &>/dev/null; then
        useradd -M -s /sbin/nologin "$USERNAME"
    fi

    echo "$USERNAME:$PASSWORD" | chpasswd
done

# Запуск Dante с конфигом
danted -f /danted.conf -D
