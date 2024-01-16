Playbook
=========

This playbook install  lighthouse, clickhouse and vector using ansible. <br>

LightHouse is a lightweight GUI interface for ClickHouse. <br>
More about lighthouse you can read here: https://github.com/VKCOM/lighthouse <br>

More about vector you can read here: https://vector.dev/ <br>

More about clickhouse you can read here: https://clickhouse.com/ <br>

Requirements
------------

Ansible version >=2.15 (It might work on previos versions, but i can't garantee it )

Role Variables
--------------

| Name               | Default Value   | Description                |
| ------------------ | --------------- | -------------------------- |
| lighthouse_dest    | /opt/lighthouse | folder location            |
| vector_version     | 0.33.0          | vector package version     |
| clickhouse_version | 22.3.3.44       | clickhouse package version |


Example Playbook
----------------

First, set your ip address in `/inventory/prod.yml` <br> 

Then run: 
```bash
ansible-playbook -i /inventory site.yml
```

License
-------

BSD
