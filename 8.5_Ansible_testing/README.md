# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

#### 1. Установите molecule: `pip3 install "molecule==3.5.2"` и драйвера `pip3 install molecule_docker molecule_podman`.

```
выполнено
```

#### 2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

```
выполнено
```

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

#### 1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.

протестировал, получено достаточно большое количество ошибок, в том числе:

```bash
TASK [Apply Clickhouse Role] ***************************************************
ERROR! the role 'ansible-clickhouse' was not found in /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/resources/playbooks/roles:/Users/shlagin/.cache/molecule/clickhouse/centos_7/roles:/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles:/Users/shlagin/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse:/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/resources/playbooks

The error appears to be in '/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/resources/playbooks/converge.yml': line 7, column 15, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

      include_role:
        name: ansible-clickhouse
              ^ here

PLAY RECAP *********************************************************************
centos_7                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '-D', '--inventory', '/Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory', '--skip-tags', 'molecule-notest,notest', '/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/resources/playbooks/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Inventory /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /Users/shlagin/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

 

#### 2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

```bash
➜  vector-role git:(main) ✗ molecule init scenario --driver-name docker
/Users/shlagin/Library/Python/3.9/lib/python/site-packages/urllib3/__init__.py:34: NotOpenSSLWarning: urllib3 v2 only supports OpenSSL 1.1.1+, currently the 'ssl' module is compiled with 'LibreSSL 2.8.3'. See: https://github.com/urllib3/urllib3/issues/3020
  warnings.warn(
INFO     Initializing new scenario default...
INFO     Initialized scenario in /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/vector-role/molecule/default successfully.
```

#### 3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

Тестируем роль на centos. Получаем ошибку: <br>

```
TASK [vector-role : Start vector service] **************************************
fatal: [centos_7]: FAILED! => {"changed": false, "msg": "Service is in unknown state", "status": {}}
```

Сервис не может запуститься. Я хочу понять почему, но я не могу подключиться к этому контейнеру, т.к. он удаляется

```
PLAY [Destroy] *****************************************************************
```

Вопрос - как понять почему сервис не может запуститься? Мне нужно отдельно поставить centos 7 и на нем запускать этот playbook? И после того как возникает ошибка
мне нужно зайти на centos и там разбираться в чем дело? Или есть какие то другие варианты?

```bash
➜  vector-role git:(main) ✗ molecule test -s centos_7
/Users/shlagin/Library/Python/3.9/lib/python/site-packages/urllib3/__init__.py:34: NotOpenSSLWarning: urllib3 v2 only supports OpenSSL 1.1.1+, currently the 'ssl' module is compiled with 'LibreSSL 2.8.3'. See: https://github.com/urllib3/urllib3/issues/3020
  warnings.warn(
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/Users/shlagin/.cache/ansible-compat/f5bcd7/modules:/Users/shlagin/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/Users/shlagin/.cache/ansible-compat/f5bcd7/collections:/Users/shlagin/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/Users/shlagin/.cache/ansible-compat/f5bcd7/roles:/Users/shlagin/Documents/Ansible/Roles:/Users/shlagin/Documents/Ansible/Roles/netology
INFO     Running centos_7 > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos_7 > lint
INFO     Lint is disabled.
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running centos_7 > syntax

playbook: /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/vector-role/molecule/centos_7/converge.yml
INFO     Running centos_7 > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}) 
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/centos:7) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j373630909657.56327', 'results_file': '/Users/shlagin/.ansible_async/j373630909657.56327', 'changed': True, 'item': {'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running centos_7 > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos_7 > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos_7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Install sudo for CentOS (if not installed)] ****************
changed: [centos_7]

TASK [vector-role : Get vector distrib for Debian/Ubuntu] **********************
skipping: [centos_7]

TASK [vector-role : Install vector package on Debian/Ubuntu] *******************
skipping: [centos_7]

TASK [vector-role : Get vector distrib for RedHat/CentOS] **********************
changed: [centos_7]

TASK [vector-role : Install vector package on RedHat/CentOS] *******************
changed: [centos_7]

TASK [vector-role : Enable vector] *********************************************
changed: [centos_7]

TASK [vector-role : Start vector service] **************************************
fatal: [centos_7]: FAILED! => {"changed": false, "msg": "Service is in unknown state", "status": {}}

PLAY RECAP *********************************************************************
centos_7                   : ok=5    changed=4    unreachable=0    failed=1    skipped=2    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/Users/shlagin/.cache/molecule/vector-role/centos_7/inventory', '--skip-tags', 'molecule-notest,notest', '/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/vector-role/molecule/centos_7/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos_7 > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

Тестируем роль на ubuntu. Получаю ошибку что не установлен python. Поставить python через raw module

```bash
- name: Install Python3 using raw module
  raw: apt-get install -y python3
```

я не могу, т.е. ansible собирает факты и не может их собрать (питона же нет) <br>
Т.е. мне надо как то поставить питон на ubuntu. Как это сделать? <br>

```bash
➜  vector-role git:(main) ✗ molecule test -s ubuntu  
/Users/shlagin/Library/Python/3.9/lib/python/site-packages/urllib3/__init__.py:34: NotOpenSSLWarning: urllib3 v2 only supports OpenSSL 1.1.1+, currently the 'ssl' module is compiled with 'LibreSSL 2.8.3'. See: https://github.com/urllib3/urllib3/issues/3020
  warnings.warn(
INFO     ubuntu scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/Users/shlagin/.cache/ansible-compat/f5bcd7/modules:/Users/shlagin/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/Users/shlagin/.cache/ansible-compat/f5bcd7/collections:/Users/shlagin/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/Users/shlagin/.cache/ansible-compat/f5bcd7/roles:/Users/shlagin/Documents/Ansible/Roles:/Users/shlagin/Documents/Ansible/Roles/netology
INFO     Running ubuntu > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntu > lint
INFO     Lint is disabled.
INFO     Running ubuntu > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running ubuntu > syntax

playbook: /Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/vector-role/molecule/ubuntu/converge.yml
INFO     Running ubuntu > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}) 
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j486777117981.56873', 'results_file': '/Users/shlagin/.ansible_async/j486777117981.56873', 'changed': True, 'item': {'image': 'ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running ubuntu > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntu > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
fatal: [ubuntu]: FAILED! => {"ansible_facts": {}, "changed": false, "failed_modules": {"ansible.legacy.setup": {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python"}, "failed": true, "module_stderr": "/bin/sh: 1: /usr/bin/python: not found\n", "module_stdout": "", "msg": "The module failed to execute correctly, you probably need to set the interpreter.\nSee stdout/stderr for the exact error", "rc": 127}}, "msg": "The following modules failed to execute: ansible.legacy.setup\n"}

PLAY RECAP *********************************************************************
ubuntu                     : ok=0    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/Users/shlagin/.cache/molecule/vector-role/ubuntu/inventory', '--skip-tags', 'molecule-notest,notest', '/Users/shlagin/Documents/DevOps-netology/homeweork-devops-netology/8.5_Ansible_testing/playbook/roles/vector-role/molecule/ubuntu/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running ubuntu > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```




#### 4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 

я добавил тесты в `verify.yml`

```bash
- name: Verify
  hosts: all
  gather_facts: false
  tasks:

    - name: Проверка валидности конфигурации Vector
      ansible.builtin.command: vector validate
      register: vector_validate
      changed_when: false

    - name: Утверждение, что конфигурация Vector валидна
      ansible.builtin.assert:
        that:
          - vector_validate.rc == 0
        fail_msg: "Конфигурация Vector невалидна"
        success_msg: "Конфигурация Vector валидна"

    - name: Получение статуса сервиса Vector
      ansible.builtin.systemd:
        name: vector
        state: started
      register: vector_service
      changed_when: false

    - name: Утверждение, что Vector успешно запущен
      ansible.builtin.assert:
        that:
          - vector_service.status.ActiveState == 'active'
        fail_msg: "Сервис Vector не запущен"
        success_msg: "Сервис Vector успешно запущен"

```

После внесения конфига я запустил тест повторно - ничего не изменилось, я не получаю никаких сообщений из `verify.yml`. Почему? 

#### 5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

#### 6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

#### 1. Добавьте в директорию с vector-role файлы из [директории](./example).

```
выполнено
```

#### 2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.



#### 3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

```bash
[root@9151de304472 vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==41.0.7,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==5.0.1,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.7.0,ruamel.yaml==0.18.5,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='157061826'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
```

#### 4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

```bash
molecule init scenario --driver-name podman
```

#### 5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

Изменил имя сценария на `default`

```bash
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37,39}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s default --destroy always}
```

#### 6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

```bash
[root@9151de304472 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==41.0.7,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==5.0.1,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.7.0,ruamel.yaml==0.18.5,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='2580881368'
py37-ansible210 run-test: commands[0] | molecule test -s default --destroy always
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '610285168638.7046', 'results_file': '/root/.ansible_async/610285168638.7046', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /opt/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: quay.io/centos/centos:stream8") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=quay.io/centos/centos:stream8) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
failed: [localhost] (item=instance) => {"ansible_job_id": "845462762983.7508", "ansible_loop_var": "item", "attempts": 5, "changed": true, "cmd": ["/usr/bin/podman", "run", "-d", "--name", "instance", "--hostname=instance", "quay.io/centos/centos:stream8", "bash", "-c", "while true; do sleep 10000; done"], "delta": "0:00:22.681944", "end": "2024-01-06 15:59:52.934228", "finished": 1, "item": {"ansible_job_id": "845462762983.7508", "ansible_loop_var": "item", "changed": true, "failed": false, "finished": 0, "item": {"image": "quay.io/centos/centos:stream8", "name": "instance", "pre_build_image": true}, "results_file": "/root/.ansible_async/845462762983.7508", "started": 1}, "msg": "non-zero return code", "rc": 125, "start": "2024-01-06 15:59:30.252284", "stderr": "Trying to pull quay.io/centos/centos:stream8...\nGetting image source signatures\nCopying blob sha256:6c507150f7e9f028ef978d633e702dab944bbda82bfbc46f6307495cf6dd9fc7\nCopying blob sha256:6c507150f7e9f028ef978d633e702dab944bbda82bfbc46f6307495cf6dd9fc7\nError: writing blob: adding layer with blob \"sha256:6c507150f7e9f028ef978d633e702dab944bbda82bfbc46f6307495cf6dd9fc7\": Error processing tar file(exit status 1): ", "stderr_lines": ["Trying to pull quay.io/centos/centos:stream8...", "Getting image source signatures", "Copying blob sha256:6c507150f7e9f028ef978d633e702dab944bbda82bfbc46f6307495cf6dd9fc7", "Copying blob sha256:6c507150f7e9f028ef978d633e702dab944bbda82bfbc46f6307495cf6dd9fc7", "Error: writing blob: adding layer with blob \"sha256:6c507150f7e9f028ef978d633e702dab944bbda82bfbc46f6307495cf6dd9fc7\": Error processing tar file(exit status 1): "], "stdout": "", "stdout_lines": []}

PLAY RECAP *********************************************************************
localhost                  : ok=7    changed=2    unreachable=0    failed=1    skipped=5    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/default/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/molecule_podman/playbooks/create.yml']
WARNING  An error occurred during the test sequence action: 'create'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '248019648282.7885', 'results_file': '/root/.ansible_async/248019648282.7885', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s default --destroy always (exited with code 1)

```





