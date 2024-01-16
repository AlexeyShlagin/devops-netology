#!/usr/bin/env python3
import socket
import time

# Список URL-адресов сервисов
services = {
    "drive.google.com": '-',
    "mail.google.com": '-',
    "google.com": '-'
}

# Получаем текущие IP-адреса 
for item in services:
    services[item] = socket.gethostbyname(item)
    print (item, services[item])

print ('\n---starting monitoring---')

# Запускаем бесконечный цикл проверки текущего IP адреса с IP из проверки выше
while True:
    for item in services:
        previois_ip = services[item]
        current_ip = socket.gethostbyname(item)
        if current_ip != previois_ip:
            print ("ERROR ", item, "IP mismatch:", previois_ip, current_ip)
        time.sleep (5)

