# Домашнее задание к занятию 5. «Elasticsearch»

## Задача 1


##### составьте Dockerfile-манифест для Elasticsearch,

```bash
# Используем образ CentOS в качестве базового образа
FROM centos:7

# Обновляем пакеты и устанавливаем необходимые зависимости
RUN yum -y update && \
    yum -y install wget perl-Digest-SHA

# Скачиваем и устанавливаем Elasticsearch
RUN cd /opt && \
    groupadd elasticsearch && \
    useradd -g elasticsearch elasticsearch &&\
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.2.0-linux-x86_64.tar.gz && \
    rm elasticsearch-8.2.0-linux-x86_64.tar.gz elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 && \
    mkdir /var/lib/data && chmod -R 777 /var/lib/data && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch-8.2.0 && \
    yum clean all

# Используем пользователя elasticsearch при запуске контейнера
USER elasticsearch

# Рабочая дирекория
WORKDIR /opt/elasticsearch-8.2.0/

# Копируем файл конфигурации
COPY elasticsearch.yml config/

# Порты
EXPOSE 9200 9300

# Точка входа
ENTRYPOINT ["bin/elasticsearch"]
```

##### соберите Docker-образ и сделайте `push` в ваш docker.io-репозиторий,

```bash
docker build -t my-elasticsearch .
```

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`,
- имя ноды должно быть `netology_test`.

elasticsearch.yml

```bash
node:
  name: netology_test
path:
  data: /var/lib/data
xpack.ml.enabled: false
```

[Cсылка](https://hub.docker.com/repository/docker/shlaginalexey/my-elasticsearch/general) на образ в репозитории dockerhub

##### запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины.

Я не смог найти пароль для пользователя `elastic`, пароль `changeme` не подошел.
Пришлось зайти внутрь docker контейнера и поменять пароли с помощью команды `bin/elasticsearch-setup-passwords interactive`

Скажите, какой пароль у пользователя `elastic` по умолчанию? 
Или у меня где то ошибка в конфигурационных файлах?

```bash
root@sysadm-fs2:/home/vagrant/netology/6.5# curl --insecure -u elastic https://localhost:9200
Enter host password for user 'elastic':
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "bGhjulNYRM2rpCN7fKwy0A",
  "version" : {
    "number" : "8.2.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "b174af62e8dd9f4ac4d25875e9381ffe2b9282c5",
    "build_date" : "2022-04-20T10:35:10.180408517Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:

| Имя   | Количество реплик | Количество шард |
| ----- | ----------------- | --------------- |
| ind-1 | 0                 | 1               |
| ind-2 | 1                 | 2               |
| ind-3 | 2                 | 4               |

```bash
curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'

curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,  
      "number_of_replicas": 1 
    }
  }
}
'

curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 4,  
      "number_of_replicas": 2 
    }
  }
}
'
```

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

```bash
curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
```

```bash
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   ind-3 a0tQ7ZsXSYCUNdMcrUe_Yg   4   2          0            0       900b           900b
green  open   ind-1 n49NSx9DT4KoaTHp1SkXDQ   1   0          0            0       225b           225b
yellow open   ind-2 ckiQ8OTzRPmEqXbzx-qN4g   2   1          0            0       450b           450b
```

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?
```bash
В `ind-3` и `ind-2` количество реплик более 1-ой. Реплицировать данные некуда, поэтому индекс yellow.
```

Удалите все индексы.

```bash
curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-1?pretty"
curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-2?pretty"
curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-3?pretty"
```

## Задача 3

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

```bash
[elasticsearch@40eab2c60f2c elasticsearch-8.2.0]$ mkdir snapshots
```

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
эту директорию как `snapshot repository` c именем `netology_backup`.

Добавляем path в elasticsearch.yml
```bash
[elasticsearch@40eab2c60f2c elasticsearch-8.2.0]$ cat ./config/elasticsearch.yml
node:
  name: netology_test
path:
  data: /var/lib/data
xpack.ml.enabled: false
path.repo: ["/opt/elasticsearch-8.2.0/snapshots"]
```

```bash
root@sysadm-fs2:/home/vagrant/netology/6.5# curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
>   "type": "fs",
>   "settings": {
>     "location": "/opt/elasticsearch-8.2.0/snapshots"
>   }
> }
> '
{
  "acknowledged" : true
}
```


Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash
curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'
```

```bash
root@sysadm-fs2:/home/vagrant/netology/6.5# curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  uh4PFBLaQfmCwpVUWNi9eA   1   0          0            0       225b           225b
```


[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `Elasticsearch`.

```bash
curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup/snapshot_name?wait_for_completion=true" -H 'Content-Type: application/json' -d'
{
  "indices": "_all", 
  "ignore_unavailable": true,
  "include_global_state": true
}
'
```

**Приведите в ответе** список файлов в директории со `snapshot`.

```bash
[elasticsearch@40eab2c60f2c snapshots]$ ls -lah .
total 48K
drwxrwxr-x 3 elasticsearch elasticsearch 4.0K Sep 11 10:34 .
drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Sep 11 10:23 ..
-rw-r--r-- 1 elasticsearch elasticsearch 1.1K Sep 11 10:34 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Sep 11 10:34 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch 4.0K Sep 11 10:33 indices
-rw-r--r-- 1 elasticsearch elasticsearch  17K Sep 11 10:34 meta-SCSTh4b3QBKfRYXpYyWVSA.dat
-rw-r--r-- 1 elasticsearch elasticsearch  388 Sep 11 10:34 snap-SCSTh4b3QBKfRYXpYyWVSA.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
[elasticsearch@40eab2c60f2c snapshots]$ curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/test?pretty"
{
  "acknowledged" : true
}
```

```bash
curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'
```

```bash
[elasticsearch@40eab2c60f2c snapshots]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 fmaR9L98SYOx2w5lInctsg   1   0          0            0       225b           225b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее. 

```bash
[elasticsearch@40eab2c60f2c snapshots]$ curl -X POST --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup/snapshot_name/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "*",
>   "include_global_state": true
> }
> '
{
  "accepted" : true
}
```

```bash
[elasticsearch@40eab2c60f2c snapshots]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   g4p7_9JdRwC_mq0Th-j0eg   1   0          0            0       225b           225b
green  open   test-2 fmaR9L98SYOx2w5lInctsg   1   0          0            0       225b           225b
```



