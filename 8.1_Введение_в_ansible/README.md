# Домашнее задание к занятию 1 «Введение в Ansible»

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

```bash
playbook git:(main) ✗ ansible-playbook -i ./inventory/test.yml site.yml

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

examp.yml

```bash
---
  some_fact: all default fact
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

Создаем 2 контейнера с помощью `docker-compose.yml`:

```bash
version: '3'

services:
  centos7:
    image: centos:7
    container_name: hw_8.1_centos7
    tty: true
    command: /bin/bash -c "yum -y update && yum -y install -y python3 && exec /bin/bash"

  ubuntu:
    image: ubuntu
    container_name: hw_8_1_ubuntu
    tty: true
    command: /bin/bash -c "apt-get -y update && apt-get -y install -y python3 && exec /bin/bash"

```

запускаем: 

```bash
docker-compose up -d
```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```bash
➜  playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *********************************************************************************

TASK [Gathering Facts] ********************************************************************************
ok: [hw_8_1_ubuntu]
ok: [hw_8.1_centos7]

TASK [Print OS] ***************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "CentOS"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "el"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ********************************************************************************************
hw_8.1_centos7             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
hw_8_1_ubuntu              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

```bash
➜  playbook git:(main) ✗ cat ./group_vars/el/examp.yml
---
  some_fact: "el default fact"
```

```bash
➜  playbook git:(main) ✗ cat ./group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
```

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```bash
➜  playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *********************************************************************************

TASK [Gathering Facts] ********************************************************************************
ok: [hw_8_1_ubuntu]
ok: [hw_8.1_centos7]

TASK [Print OS] ***************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "CentOS"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "el default fact"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ********************************************************************************************
hw_8.1_centos7             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
hw_8_1_ubuntu              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```bash
playbook git:(main) ✗ ansible-vault encrypt group_vars/deb/examp.yml 
```

```bash
playbook git:(main) ✗ ansible-vault encrypt group_vars/el/examp.yml 
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```bash
➜  playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***********************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************
ok: [hw_8_1_ubuntu]
ok: [hw_8.1_centos7]

TASK [Print OS] *****************************************************************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "CentOS"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***************************************************************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "el default fact"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************************************************************************************************************************
hw_8.1_centos7             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hw_8_1_ubuntu              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```bash
➜  ~ ansible-doc -t connection -l
ansible.builtin.local          execute on controller
 ```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```bash
---
  el:
    hosts:
      hw_8.1_centos7:
        ansible_connection: docker
  deb:
    hosts:
      hw_8_1_ubuntu:
        ansible_connection: docker
  local:
    hosts:
      ansible_connection: local
```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```bash
playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ********************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [hw_8_1_ubuntu]
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /Library/Frameworks/Python.framework/Versions/3.11/bin/python3.11, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [hw_8.1_centos7]

TASK [Print OS] **************************************************************************************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "CentOS"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ************************************************************************************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "el default fact"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *******************************************************************************************************************************************************************
hw_8.1_centos7             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hw_8_1_ubuntu              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

`выполнено`

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```bash
➜  playbook git:(main) ✗ ansible-vault decrypt group_vars/deb/examp.yml 
Vault password: 
Decryption successful
➜  playbook git:(main) ✗ ansible-vault decrypt group_vars/el/examp.yml
Vault password: 
Decryption successful
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

`examp.yml`
```bash
---
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          65366238636637303937393137323465346234643836663334643763616133353665636431646633
          6337666264333465626262653366333537356566616438660a383136313162623762366130386234
          36653739326632343037346366623136376633623266303439663138306330373531376263306666
          3639656537653032620a353230666238383833656461383135333566386439313730643866373031
          3934
```


3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```bash
➜  playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ********************************************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at /Library/Frameworks/Python.framework/Versions/3.11/bin/python3.11, but future
installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [hw_8_1_ubuntu]
ok: [hw_8.1_centos7]

TASK [Print OS] **************************************************************************************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "CentOS"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ************************************************************************************************************************************************************
ok: [hw_8.1_centos7] => {
    "msg": "el default fact"
}
ok: [hw_8_1_ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *******************************************************************************************************************************************************************
hw_8.1_centos7             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
hw_8_1_ubuntu              : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).

```bash
version: '3'

services:
  centos7:
    image: centos:7
    container_name: hw_8.1_centos7
    tty: true
    command: /bin/bash -c "yum -y update && yum -y install -y python3 && exec /bin/bash"

  ubuntu:
    image: ubuntu
    container_name: hw_8_1_ubuntu
    tty: true
    command: /bin/bash -c "apt-get -y update && apt-get -y install -y python3 && exec /bin/bash"

  fedora:
    image: pycontribs/fedora
    container_name: hw_8_1_fedora
    tty: true

```

```bash
---
  el:
    hosts:
      hw_8.1_centos7:
        ansible_connection: docker
  deb:
    hosts:
      hw_8_1_ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
  fed:
    hosts:
      hw_8_1_fedora:
        ansible_connection: docker
```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

```bash
#!/bin/bash
docker-compose -f ./docker/docker-compose.yml up -d 
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass
docker-compose -f ./docker/docker-compose.yml down
```
