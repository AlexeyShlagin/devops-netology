Role Name
=========

This role install vector using ansible. <br>
More about vector you can read here: https://vector.dev/

Requirements
------------

Ansible version >=2.15 (It might work on previos versions, but i can't garantee it )

Role Variables
--------------

| Name           | Default Value | Description            |
| -------------- | ------------- | ---------------------- |
| vector_version | 0.33.0        | Vector package version |


Example Playbook
----------------

Example of how to use role:

```yml
- name: Installing Vector
  hosts: vector
  roles:
    - role: vector-role   
```

License
-------

BSD
