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

#### 2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.

#### 3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

#### 4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

#### 5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

#### 6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

#### 7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

