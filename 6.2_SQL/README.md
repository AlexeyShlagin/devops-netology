# Домашнее задание к занятию 2. «SQL»
root@sysadm-fs2:/home/vagrant/netology/6.2# cat docker-compose.yml
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: postgres_instance
    environment:
      POSTGRES_DB: netology
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 123
    volumes:
      - postgres_bups:/backups
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5433:5432"

volumes:
  postgres_bups:
    driver: local
    name: 6.2_postgres_bups
  postgres_data:
    driver: local
    name: 6.2_postgres_data
```

```
test_db=# \l
                                    List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+-----------------+----------+------------+------------+-----------------------
 netology  | postgres        | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres        | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |                 |          |            |            | postgres=CTc/postgres
 template1 | postgres        | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |                 |          |            |            | postgres=CTc/postgres
 test_db   | test_admin_user | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```

test_db=# \d+ orders
                                                           Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description

--------------+------------------------+-----------+----------+------------------------------------+----------+--------------+------------
-
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 наименование | character varying(100) |           |          |                                    | extended |              |
 цена         | integer                |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```
test_db=# \d+ clients
                                                             Table "public.clients"
      Column       |         Type          | Collation | Nullable |               Default               | Storage  | Stats target | Descri
ption
-------------------+-----------------------+-----------+----------+-------------------------------------+----------+--------------+-------
------
 id                | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 фамилия           | character varying(50) |           |          |                                     | extended |              |
 страна_проживания | character varying(50) |           |          |                                     | extended |              |
 заказ             | integer               |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```
SELECT 
    grantee,
    table_name,
    string_agg(privilege_type, ', ') AS privileges
FROM information_schema.table_privileges
WHERE table_schema = 'public' AND table_catalog = 'test_db'
GROUP BY grantee, table_name;

```
     grantee      | table_name |                          privileges
------------------+------------+---------------------------------------------------------------
 postgres         | clients    | TRIGGER, REFERENCES, TRUNCATE, DELETE, UPDATE, SELECT, INSERT
 postgres         | orders     | INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
 test_admin_user  | clients    | DELETE, TRIGGER, REFERENCES, TRUNCATE, INSERT, SELECT, UPDATE
 test_admin_user  | orders     | DELETE, UPDATE, SELECT, INSERT, TRIGGER, REFERENCES, TRUNCATE
 test_simple_user | clients    | DELETE, INSERT, SELECT, UPDATE
 test_simple_user | orders     | INSERT, DELETE, UPDATE, SELECT
(6 rows)
```

```
test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```
UPDATE clients
SET "заказ" = (SELECT id FROM orders WHERE наименование = 'Книга')
WHERE фамилия = 'Иванов Иван Иванович';
```
```
UPDATE clients
SET "заказ" = (SELECT id FROM orders WHERE наименование = 'Монитор')
WHERE фамилия = 'Петров Петр Петрович';
```
```
UPDATE clients
SET "заказ" = (SELECT id FROM orders WHERE наименование = 'Гитара')
WHERE фамилия = 'Иоганн Себастьян Бах';
```
test_db=# SELECT DISTINCT фамилия
FROM clients
WHERE "заказ" IS NOT NULL;
       фамилия
----------------------
 Иоганн Себастьян Бах
 Иванов Иван Иванович
 Петров Петр Петрович
(3 rows)
```


```
test_db=# EXPLAIN SELECT фамилия
FROM clients
WHERE "заказ" IS NOT NULL;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..13.00 rows=298 width=118)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```

Значения ознчают скорость выполнения запроса. Это приблизительные оценки которые могут помочь найти "узкие места" в работе с базой данных, тем самым повысив скорость работы и снизив нагрузку на серверное железо.
root@4d070eb59e7f:/# pg_dump -U postgres -d test_db -F c -f /backups/test_db.bup
root@4d070eb59e7f:/# ls /backups/
test_db.bup
```
root@sysadm-fs2:/home/vagrant/netology/6.2# docker-compose down
[+] Running 2/2
 ⠿ Container postgres_instance  Removed                                                                                              0.3s
 ⠿ Network 62_default           Removed

```
root@sysadm-fs2:/home/vagrant/netology/6.2# cat docker-compose2.yml
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: postgres_instance_2
    environment:
      POSTGRES_DB: netology
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 123
    volumes:
      - postgres_bups2:/backups
      - postgres_data2:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_bups2:
    driver: local
    name: 6.2_postgres_bups_2
  postgres_data2:
    driver: local
    name: 6.2_postgres_data_2
```

```
root@sysadm-fs2:/home/vagrant/netology/6.2# docker-compose -f docker-compose2.yml up -d
[+] Running 2/2
 ⠿ Network 62_default             Created                                                                                            0.1s
 ⠿ Container postgres_instance_2  Started
```
root@sysadm-fs2:/home/vagrant/netology/6.2# cp /var/lib/docker/volumes/6.2_postgres_bups/_data/test_db.bup /var/lib/docker/volumes/6.2_postgres_bups_2/_data/
```

заходим в контейнер и проверяем наличие бэкапа
root@187a60df13c2:/# ls /backups/
test_db.bup
```

```
root@187a60df13c2:/# psql -U postgres
psql (12.16 (Debian 12.16-1.pgdg120+1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 netology  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```
root@187a60df13c2:/# postgres=# createdb -U postgres test_db

```

```
root@187a60df13c2:/# pg_restore -U postgres --dbname test_db /backups/test_db.bup
pg_restore: while PROCESSING TOC:
pg_restore: from TOC entry 2999; 0 0 ACL TABLE clients postgres
pg_restore: error: could not execute query: ERROR:  role "test_admin_user" does not exist
Command was: GRANT ALL ON TABLE public.clients TO test_admin_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clients TO test_simple_user;


pg_restore: from TOC entry 3001; 0 0 ACL SEQUENCE clients_id_seq postgres
pg_restore: error: could not execute query: ERROR:  role "test_admin_user" does not exist
Command was: GRANT ALL ON SEQUENCE public.clients_id_seq TO test_admin_user;


pg_restore: from TOC entry 3002; 0 0 ACL TABLE orders postgres
pg_restore: error: could not execute query: ERROR:  role "test_admin_user" does not exist
Command was: GRANT ALL ON TABLE public.orders TO test_admin_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.orders TO test_simple_user;


pg_restore: from TOC entry 3004; 0 0 ACL SEQUENCE orders_id_seq postgres
pg_restore: error: could not execute query: ERROR:  role "test_admin_user" does not exist
Command was: GRANT ALL ON SEQUENCE public.orders_id_seq TO test_admin_user;


pg_restore: warning: errors ignored on restore: 4

```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 netology  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(6 rows)

```
Почему у меня не получается поднять 2 докер контейнера с postgres с помощью docker-compose?

root@sysadm-fs2:/home/vagrant/netology/6.2# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

я поднимаю первый контейнер:

```
root@sysadm-fs2:/home/vagrant/netology/6.2# docker-compose -f docker-compose.yml up -d
[+] Running 2/2
 ⠿ Network 62_default           Created                                                                                              0.1s
 ⠿ Container postgres_instance  Started
 ```
 
 конфигурационный файл:
 
 ```
 root@sysadm-fs2:/home/vagrant/netology/6.2# cat docker-compose.yml
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: postgres_instance
    environment:
      POSTGRES_DB: netology
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 123
    volumes:
      - postgres_bups:/backups
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5433:5432"

volumes:
  postgres_bups:
    driver: local
    name: 6.2_postgres_bups
  postgres_data:
    driver: local
    name: 6.2_postgres_data

```

 
Проверяем, работает: 

 ```
 root@sysadm-fs2:/home/vagrant/netology/6.2# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
a132266d0527   postgres:12   "docker-entrypoint.s…"   11 seconds ago   Up 10 seconds   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   postgres_instance
```

Если я не буду останавливать первый докер контейнер и запущу второй, то первый будет остановлен:

```
root@sysadm-fs2:/home/vagrant/netology/6.2# docker-compose -f docker-compose2.yml up -d
[+] Running 2/2
 ⠿ Container postgres_instance    Recreated                                                                                          0.3s
 ⠿ Container postgres_instance_2  Started
 ```
 
конфигурационный файл:

```
root@sysadm-fs2:/home/vagrant/netology/6.2# cat docker-compose2.yml
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: postgres_instance_2
    environment:
      POSTGRES_DB: netology
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 123
    volumes:
      - postgres_bups2:/backups
      - postgres_data2:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_bups2:
    driver: local
    name: 6.2_postgres_bups_2
  postgres_data2:
    driver: local
    name: 6.2_postgres_data_2
```
 
```
root@sysadm-fs2:/home/vagrant/netology/6.2# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
f3a05202ca85   postgres:12   "docker-entrypoint.s…"   11 seconds ago   Up 10 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres_instance_2

```
### UPDATE

Разорбался, в моих конфигурационных файлах была ошибка связанная с одинаковым именем сервиса `posgres`.

Ниже указан конфигурационный файл для поднятия 2-х контейнеров posgres:

```
version: '3'

services:
  postgres:
    image: postgres:12
    container_name: postgres_instance
    environment:
      POSTGRES_DB: netology
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 123
    volumes:
      - postgres_bups:/backups
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  postgres2:
    image: postgres:12
    container_name: postgres_instance2
    environment:
      POSTGRES_DB: netology
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 123
    volumes:
      - postgres_bups2:/backups
      - postgres_data2:/var/lib/postgresql/data
    ports:
      - "5433:5432"


volumes:
  postgres_bups:
    driver: local
    name: 6.2_postgres_bups
  postgres_data:
    driver: local
    name: 6.2_postgres_data

  postgres_bups2:
    driver: local
    name: 6.2_postgres_bups
  postgres_data2:
    driver: local
    name: 6.2_postgres_data

docker-compose3.yml (END)
```