#!/usr/bin/env python3
import socket
import time
import json
import yaml

# Список URL-адресов сервисов
services = {
    "drive.google.com": '-',
    "mail.google.com": '-',
    "google.com": '-'
}
# Очищаем файлы перед запуском
with open ('output.json', 'w') as output_json:
    output_json.write('')

with open ('output.yml', 'w') as output_yml:
    output_yml.write('')



# Получаем текущие IP-адреса 
for item in services:
    services[item] = socket.gethostbyname(item)
    print (item, services[item])

    # Записываем данные в виде json 
    with open ('output.json', 'a') as output_json:
        data_json = json.dumps({item: services[item]})
        output_json.write(f'{data_json}\n')

    # Записываем данные в виде yaml
    with open('output.yml', 'a') as output_yml:
        data_yml = yaml.dump({item: services[item]})
        output_yml.write('- ' + data_yml)

print ('\n---starting monitoring---')

# Запускаем бесконечный цикл проверки текущего IP адреса с IP из проверки выше
while True:
    for item in services:
        previois_ip = services[item]
        current_ip = socket.gethostbyname(item)
        
        # Если у одного из сервисов изменился IP - выводим ошибку и запускам цикл повторного получения IP у всех сервисов
        if current_ip != previois_ip:
            
            with open ('output.json', 'w') as output_json:
                output_json.write('')
            with open ('output.yml', 'w') as output_yml:
                output_yml.write('') 

            print ("ERROR ", item, "IP mismatch:", previois_ip, current_ip)
            for item in services:
                #print('test')

             #   previois_ip = services[item]
             #   current_ip = socket.gethostbyname(item)

                # Записываем информацию в json файл
                with open ('output.json', 'a') as output_json:
                    data_json = json.dumps({item: current_ip})
                    output_json.write(f'{data_json}\n')

                # Записываем информацию в yml файл
                with open('output.yml', 'a') as output_yml:
                    data_yml = yaml.dump({item: current_ip})
                    output_yml.write('- ' + data_yml)

        time.sleep (5)

