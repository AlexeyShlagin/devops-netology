# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
2. Установить Jenkins при помощи playbook.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

```bash
выполнено
```

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

Прошу помочь. <br>

При запуске теста из репозитория 
[devops-netology-vector-role](https://github.com/AlexeyShlagin/devops-netology-vector-role) возникают ошибки с интерпретатором `python`.


При запуске `molecule test ` я получаю ошибку:
```bash
TASK [Gathering Facts] *********************************************************
fatal: [debian_buster_slim]: FAILED! => {"ansible_facts": {}, "changed": false, "failed_modules": {"ansible.legacy.setup": {"failed": true, "module_stderr": "/bin/sh: 1: /usr/bin/python3: not found\n", "module_stdout": "", "msg": "The module failed to execute correctly, you probably need to set the interpreter.\nSee stdout/stderr for the exact error", "rc": 127}}, "msg": "The following modules failed to execute: ansible.legacy.setup\n"}

```

интерператор прописан в `molecule.yml`

```yml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: debian_buster_slim
    image: debian:buster-slim
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
  
provisioner:
  name: ansible
  inventory:
    host_vars:
      debian_buster_slim:
        ansible_python_interpreter: /usr/bin/python3
```

Перед сбором FACTS идет установка python:
```yml
- name: Install Python3
  raw: apt-get update && apt-get install -y python3
  become: true

# tasks file for vector-role
- name: Get vector distrib
...
...
```

Как правильно сделать дебаггинг (диагностику) проблемы? Мне нужно делать инвентарный файл, менять tasks/main.yml, запускать докер, туда подключаться и смотреть что установилось и что нет? Или есть более простой и правильный вариант?

---

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.


3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.


4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.


5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).


6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.


7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.


8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
