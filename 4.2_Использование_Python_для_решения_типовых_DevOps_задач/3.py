#!/usr/bin/env python3

import os
import sys

# по умолчанию используется директория в которой лежит скрипт
path = "./"

# если при запуске указана другая директория - берем ее. Если директория не существует - выводим ошибку
if len(sys.argv) > 1:
    path = sys.argv[1]

    if not os.path.exists(path):
        print(f"Error: Directory '{path}' does not exist")
        sys.exit(1)        
    
bash_command = ["cd " +path, "git status"]

result_os = os.popen(' && '.join(bash_command)).read()
print(' && '.join(bash_command))

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        