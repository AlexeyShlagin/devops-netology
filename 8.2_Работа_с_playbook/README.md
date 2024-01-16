# Домашнее задание к занятию 2 «Работа с Playbook»

#### 1. Подготовьте свой inventory-файл `prod.yml`.


`prod.yml`
```bash
---
clickhouse:
  hosts:
    hw_8_2_clickhouse:
      ansible_python_interpreter: /usr/bin/python2.7
      #ansible_connection: docker
      ansible_host: 158.160.99.7
      ansible_user: ansible

vector:
  hosts:
    hw_8_2_vector:
      ansible_python_interpreter: /usr/bin/python3
      ansible_host: 158.160.126.205
      ansible_user: ansible
      # ansible_connection: docker

# Группируем дистрибутивы для удобства установки пакетов
red_hat_based_distribs:
  hosts:
    hw_8_2_clickhouse:

debian_based_distribs:
  hosts:
    hw_8_2_vector:

```

#### 2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install).

```bash
---

# Устанавливаем корневые сертификаты
  - name: CA certificates
    hosts: all
    tasks:
      - name: Install CA
        become: yes
        ansible.builtin.package:
          name: ca-certificates
          state: latest

# Устанавливаем clickhouse
  - name: Install Clickhouse
    hosts: clickhouse
    
    handlers:
      - name: Restart clickhouse service
        become: true
        ansible.builtin.service:
          name: clickhouse-server
          state: restarted
    
    tasks:
      # Скачиваем пакеты: клиент, сервер
      - name: Get clickhouse client server distrib
        ansible.builtin.get_url:
          url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
          dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
        with_items: "{{ clickhouse_packages_client_server }}"

      # Скачиваем common static, если нет в одном репозитории - берем в другом
      - block:
          - name: Get clickhouse common static noarch distrib
            ansible.builtin.get_url:
              url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
              dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
            with_items: "{{ clickhouse_packages_common_static }}"
        rescue:    
          - name: Get clickhouse common static x86_64 distrib
            ansible.builtin.get_url:
              url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
              dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
      
      # Устанавливаем пакеты
      - name: Install clickhouse packages
        become: true
        ansible.builtin.yum:
          name:
            - "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
            - ./clickhouse-client-{{ clickhouse_version }}.rpm
            - ./clickhouse-server-{{ clickhouse_version }}.rpm
          state: present
        #changed_when: true
        
        notify: Restart clickhouse service
      - name: Flush handlers
        meta: flush_handlers

      - name: Create database
        ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
        register: create_db
        failed_when: create_db.rc != 0 and create_db.rc !=82
        changed_when: create_db.rc == 0
        
# Устанавливаем vector      
  - name: Installing Vector
    hosts: vector
    tasks:
      - name: Get vector distrib
        ansible.builtin.get_url:
          url: "https://packages.timber.io/vector/{{ vector_version }}/vector_0.33.0-1_amd64.deb"        
          dest: "./{{ vector_version }}_amd64.deb"
      - name: Install package vector
        become: true
        ansible.builtin.apt:
          deb: "./{{ vector_version }}_amd64.deb"
          state: present

      - name: Enable vector
        become: true
        ansible.builtin.shell: systemctl enable vector.service

      - name: Start vector service
        become: true
        ansible.builtin.service:
          name: vector.service
          state: restarted           

```

#### 3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

#### 4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

#### 5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml                                             

PLAY [CA certificates] *********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [hw_8_2_vector]
ok: [hw_8_2_clickhouse]

TASK [Install CA] **************************************************************************************************************
ok: [hw_8_2_clickhouse]
ok: [hw_8_2_vector]

PLAY [Install Clickhouse] ******************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [hw_8_2_clickhouse]

TASK [Get clickhouse client server distrib] ************************************************************************************
ok: [hw_8_2_clickhouse] => (item=clickhouse-client)
ok: [hw_8_2_clickhouse] => (item=clickhouse-server)

TASK [Get clickhouse common static noarch distrib] *****************************************************************************
failed: [hw_8_2_clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "ansible", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "ansible", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse common static x86_64 distrib] *****************************************************************************
ok: [hw_8_2_clickhouse]

TASK [Install clickhouse packages] *********************************************************************************************
ok: [hw_8_2_clickhouse]

TASK [Flush handlers] **********************************************************************************************************

TASK [Create database] *********************************************************************************************************
ok: [hw_8_2_clickhouse]

PLAY [Installing Vector] *******************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************
ok: [hw_8_2_vector]

TASK [Get vector distrib] ******************************************************************************************************
ok: [hw_8_2_vector]

TASK [Install package vector] **************************************************************************************************
ok: [hw_8_2_vector]

TASK [Enable vector] ***********************************************************************************************************
changed: [hw_8_2_vector]

TASK [Start vector service] ****************************************************************************************************
changed: [hw_8_2_vector]

PLAY RECAP *********************************************************************************************************************
hw_8_2_clickhouse          : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
hw_8_2_vector              : ok=7    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

#### 6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
➜  playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [CA certificates] *****************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [hw_8_2_clickhouse]
ok: [hw_8_2_vector]

TASK [Install CA] **********************************************************************************************************************************************************************
ok: [hw_8_2_vector]
ok: [hw_8_2_clickhouse]

PLAY [Install Clickhouse] **************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [hw_8_2_clickhouse]

TASK [Get clickhouse client server distrib] ********************************************************************************************************************************************
ok: [hw_8_2_clickhouse] => (item=clickhouse-client)
ok: [hw_8_2_clickhouse] => (item=clickhouse-server)

TASK [Get clickhouse common static noarch distrib] *************************************************************************************************************************************
failed: [hw_8_2_clickhouse] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "ansible", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "ansible", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse common static x86_64 distrib] *************************************************************************************************************************************
ok: [hw_8_2_clickhouse]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************
ok: [hw_8_2_clickhouse]

TASK [Flush handlers] ******************************************************************************************************************************************************************

TASK [Create database] *****************************************************************************************************************************************************************
skipping: [hw_8_2_clickhouse]

PLAY [Installing Vector] ***************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [hw_8_2_vector]

TASK [Get vector distrib] **************************************************************************************************************************************************************
ok: [hw_8_2_vector]

TASK [Install package vector] **********************************************************************************************************************************************************
ok: [hw_8_2_vector]

TASK [Enable vector] *******************************************************************************************************************************************************************
skipping: [hw_8_2_vector]

TASK [Start vector service] ************************************************************************************************************************************************************
changed: [hw_8_2_vector]

PLAY RECAP *****************************************************************************************************************************************************************************
hw_8_2_clickhouse          : ok=6    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
hw_8_2_vector              : ok=6    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0  
```

#### 7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
PLAY RECAP *****************************************************************************************************************************************************************************
hw_8_2_clickhouse          : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
hw_8_2_vector              : ok=7    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

#### 8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
PLAY RECAP *****************************************************************************************************************************************************************************
hw_8_2_clickhouse          : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
hw_8_2_vector              : ok=7    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```


#### 10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


