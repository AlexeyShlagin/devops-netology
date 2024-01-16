# Домашнее задание к занятию 5. «Оркестрация кластером Docker контейнеров на примере Docker Swarm»---## Задача 1Дайте письменые ответы на вопросы:**В чём отличие режимов работы сервисов в Docker Swarm-кластере: replication и global?**

В режиме "replication" контейнеры сервиса будут развернуты на определенном количестве узлов в кластере согласно заданному количеству реплик (копий). Например, у нас 5 нод, 4 реплики - значит на 4-х нодах развернуты контейнеры, а 5-ая нода стоит в "режиме ожидания". При падении одной из нод, контейнер будет развернут на 5-ой ноде.

В режиме "global" каждый узел в кластере будет запускать по одному экземпляру контейнера для данного сервиса. Это означает, что количество контейнеров будет соответствовать количеству доступных узлов в кластере.
**Какой алгоритм выбора лидера используется в Docker Swarm-кластере?**

Docker Swarm использует алгоритм выбора лидера, известный как "Raft consensus algorithm" (алгоритм консенсуса Raft), для выбора и управления лидером в кластере.
**Что такое Overlay Network?**

Overlay Network (сеть оверлея) - это тип сети, создаваемой поверх существующей инфраструктуры сети, такой как физические сети или сети виртуальных машин. Оверлейная сеть позволяет виртуальным устройствам, таким как контейнеры, взаимодействовать и общаться друг с другом, независимо от того, где они развернуты в реальной сетевой инфраструктуре.## Задача 2Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.```
[centos@manager ~]$ sudo docker node ls
ID                            HOSTNAME                             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
6ty6kz7ga4bi0415fv9rme07f     fhm0m4mnir2drj5u499u.auto.internal   Ready     Active                          24.0.5
6ygge2nfzeqvt2zwd19x4z0o9     fhmq286pkmbioglub3ms.auto.internal   Ready     Active                          24.0.5
dqs8307rtbie2myxslbbk2nr7     fhmtv5jurumdfg05dqkk.auto.internal   Ready     Active                          24.0.5
sl7dwuskfgr5c6npn48viifpp *   manager                              Ready     Active         Leader           24.0.5
```## Задача 3Создайте ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
```
[centos@manager ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
kbf7i2y1qkbo   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
sxoyt5eygcqk   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
p9dvrdfmbjbp   swarm_monitoring_cadvisor           global       4/4        google/cadvisor:latest
asj7ge128w2y   swarm_monitoring_dockerd-exporter   global       4/4        stefanprodan/caddy:latest
9eqnlxbhefq2   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
oce4q1rassy9   swarm_monitoring_node-exporter      global       4/4        stefanprodan/swarmprom-node-exporter:v0.16.0
1kt2y743gwmi   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
mi5x7dxgbina   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```## Задача 4 (*)Выполните на лидере Docker Swarm-кластера команду, указанную ниже, и дайте письменное описание её функционала — что она делает и зачем нужна:```docker swarm update --autolock=true```

```
[centos@manager ~]$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-ErVxHA0P4TpzumWwhA/8VE/OXZ41Hr/TNG8VI00xO4w

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```Команда "docker swarm update --autolock=true" используется для обновления параметров и настроек Docker Swarm, который является инструментом для оркестрации контейнеров в кластере. В данном случае, параметр "--autolock=true" включает автоматическую блокировку управления состоянием кластера.

Автоматическая блокировка служит для защиты состояния кластера и предотвращения несанкционированных изменений. Когда кластер Docker Swarm блокируется, это означает, что определенные операции, такие как добавление или удаление узлов, изменения конфигурации и др., требуют дополнительных шагов аутентификации, обеспечивая более высокий уровень безопасности.

Если параметр "--autolock=true" установлен, то после перезагрузки узла кластера Docker Swarm потребуется ввод мастер-ключа для разблокировки и возможности проведения изменений. Это помогает предотвратить случайное или злонамеренное внесение изменений в состояние кластера.