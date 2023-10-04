# Домашнее задание к занятию 2 «Работа с Playbook»

#### 1. Подготовьте свой inventory-файл `prod.yml`.

`docker-compose.yml`
```bash
version: '3'

services:
  clickhouse:
    image: ubuntu
    container_name: hw_8_2_clickhouse
    tty: true
    command: /bin/bash -c "apt-get -y update && apt-get -y install -y python3 && exec /bin/bash"

  vector:
    image: ubuntu
    container_name: hw_8_2_vector
    tty: true
    command: /bin/bash -c "apt-get -y update && apt-get -y install -y python3 && exec /bin/bash"

```

`prod.yml`
```bash
---
clickhouse:
  hosts:
    hw_8_2_ubuntu:
      ansible_connection: docker
```

#### 2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install).

#### 3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

#### 4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

при запуске playbook
```bash
ansible-playbook -i inventory/prod.yml site.yml --start-at-task 'Get vector distrib'
```

я получаю ошибку связанную с сертификатами:
```bash
TASK [Get vector distrib] **************************************************************************
fatal: [hw_8_2_vector]: FAILED! => {"changed": false, "dest": "./0.33.0_amd64.deb", "elapsed": 1, "msg": "Request failed: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1007)>", "url": "https://packages.timber.io/vector/0.33.0/vector_0.33.0-1_amd64.deb"}
```

Я не понимаю почему происходит эта ошибка. Что то не то с корневыми сертификатами? Я пробовал установить сертификаты с помощью скрипта:

```bash
#!/bin/sh

/Library/Frameworks/Python.framework/Versions/3.11/bin/python3.11 << "EOF"

# install_certifi.py
#
# sample script to install or update a set of default Root Certificates
# for the ssl module.  Uses the certificates provided by the certifi package:
#       https://pypi.org/project/certifi/

import os
import os.path
import ssl
import stat
import subprocess
import sys

STAT_0o775 = ( stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR
             | stat.S_IRGRP | stat.S_IWGRP | stat.S_IXGRP
             | stat.S_IROTH |                stat.S_IXOTH )

def main():
    openssl_dir, openssl_cafile = os.path.split(
        ssl.get_default_verify_paths().openssl_cafile)

    print(" -- pip install --upgrade certifi")
    subprocess.check_call([sys.executable,
        "-E", "-s", "-m", "pip", "install", "--upgrade", "certifi"])

    import certifi

    # change working directory to the default SSL directory
    os.chdir(openssl_dir)
    relpath_to_certifi_cafile = os.path.relpath(certifi.where())
    print(" -- removing any existing file or link")
    try:
        os.remove(openssl_cafile)
    except FileNotFoundError:
        pass
    print(" -- creating symlink to certifi certificate bundle")
    os.symlink(relpath_to_certifi_cafile, openssl_cafile)
    print(" -- setting permissions")
    os.chmod(openssl_cafile, STAT_0o775)
    print(" -- update complete")

if __name__ == '__main__':
    main()
EOF
```

пробовал обновить сертификаты с помощью `brew`
```bash
  brew upgrade openssl
  ```

Можно отключить проверку, с помощью `validate_certs: no`, но проблему с сертификатами это не решит.

#### 5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.


#### 6. Попробуйте запустить playbook на этом окружении с флагом `--check`.


#### 7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.


#### 8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.


#### 9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook).


#### 10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


