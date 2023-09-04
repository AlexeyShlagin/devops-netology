# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```
version: '3'

services:
  postgres13:
    image: postgres:13
    container_name: postgres13_instance
    environment:
      MYSQL_ROOT_PASSWORD: 123
    volumes:
      - postgres_bups:/backups
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_bups:
    driver: local
    name: 6.4_postgres_bups
  postgres_data:
    driver: local
    name: 6.4_postgres_data
docker-compose.yml (END)
```
 

Подключитесь к БД PostgreSQL, используя `psql`.

```
root@2a0bfaaadc32:/# psql -U postgres
psql (13.12 (Debian 13.12-1.pgdg120+1))
Type "help" for help.

postgres=#
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,

```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

- подключения к БД,

```
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```

- вывода списка таблиц,

```
postgres=# \dt
Did not find any relations.
```

- вывода описания содержимого таблиц,

```
postgres=# \d pg_database
               Table "pg_catalog.pg_database"
    Column     |   Type    | Collation | Nullable | Default
---------------+-----------+-----------+----------+---------
 oid           | oid       |           | not null |
 datname       | name      |           | not null |
 datdba        | oid       |           | not null |
 encoding      | integer   |           | not null |
 datcollate    | name      |           | not null |
 datctype      | name      |           | not null |
 datistemplate | boolean   |           | not null |
 datallowconn  | boolean   |           | not null |
 datconnlimit  | integer   |           | not null |
 datlastsysoid | oid       |           | not null |
 datfrozenxid  | xid       |           | not null |
 datminmxid    | xid       |           | not null |
 dattablespace | oid       |           | not null |
 datacl        | aclitem[] |           |          |
Indexes:
    "pg_database_datname_index" UNIQUE, btree (datname), tablespace "pg_global"
    "pg_database_oid_index" UNIQUE, btree (oid), tablespace "pg_global"
Tablespace: "pg_global"
```

- выхода из psql.

```
postgres=# \q
root@2a0bfaaadc32:/#
```

## Задача 2

Используя `psql`, создайте БД `test_database`.

```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```
root@2a0bfaaadc32:/# psql -U postgres test_database < /backups/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

```
root@2a0bfaaadc32:/# psql -U postgres
psql (13.12 (Debian 13.12-1.pgdg120+1))
Type "help" for help.

postgres=#
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=#
```
```
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```
test_database=# SELECT attname, avg_width
FROM pg_stats
WHERE tablename = 'orders'
ORDER BY avg_width DESC;
 attname | avg_width
---------+-----------
 title   |        16
 id      |         4
 price   |         4
(3 rows)
```


## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Создаем 2 новые таблицы, за основу берем таблицу `orders`.

```
CREATE TABLE orders_price_less_equal_499 (
    LIKE orders  
);

CREATE TABLE orders_price_more_499 (
    LIKE orders  
);
```
проверяем:
```
test_database=# \d
                     List of relations
 Schema |            Name             |   Type   |  Owner
--------+-----------------------------+----------+----------
 public | orders                      | table    | postgres
 public | orders_id_seq               | sequence | postgres
 public | orders_price_less_equal_499 | table    | postgres
 public | orders_price_more_499       | table    | postgres
(4 rows)
```

---
##### ВОПРОС 
Я создаел 2 таблицы `orders_price_less_equal_499` и `orders_price_more_499`. Что насчет индексов? У старой таблицы есть `orders_id_seq`, у новых нет. Нужно ли дополнительно копировать или создавать индексы? 

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

---

Копируем данные в новые таблицы с помощью транзакции

```
test_database=# BEGIN;
INSERT INTO orders_price_more_499 SELECT * FROM orders WHERE price > 499;
INSERT INTO orders_price_less_equal_499 SELECT * FROM orders WHERE price <= 499;
COMMIT;
BEGIN
INSERT 0 3
INSERT 0 5
COMMIT
```

Проверяем

```
test_database=# SELECT * FROM orders_price_less_equal_499;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# SELECT * FROM orders_price_more_499;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)
```

удаляем таблицу orders
```
test_database=# DROP TABLE orders;
DROP TABLE
```
```
test_database=# \d
                    List of relations
 Schema |            Name             | Type  |  Owner
--------+-----------------------------+-------+----------
 public | orders_price_less_equal_499 | table | postgres
 public | orders_price_more_499       | table | postgres
(2 rows)
```
**Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?**

Да, при проектировании таблицы "orders" в исходной базе данных можно было бы изначально предусмотреть автоматическое разбиение данных без необходимости "ручного" шардирования. Это называется автоматическим горизонтальным шардированием или разделением данных на подтаблицы (partitioning).

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

```bash
root@2a0bfaaadc32:/# pg_dump -U postgres -d test_database -F c -f /backups/test_database_bup.dump
```
```bash
root@2a0bfaaadc32:/# ls -lah /backups/
total 16K
drwxr-xr-x 2 root root 4.0K Sep  4 11:40 .
drwxr-xr-x 1 root root 4.0K Sep  2 05:29 ..
-rw-r--r-- 1 root root 2.2K Sep  4 11:40 test_database_bup.dump
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

создать индексы:
```
CREATE UNIQUE INDEX unique_title_index ON public.orders_price_less_equal_499 (title);
```
