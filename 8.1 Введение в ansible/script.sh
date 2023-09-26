#!/bin/bash
docker-compose -f ./docker/docker-compose.yml up -d 
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass
docker-compose -f ./docker/docker-compose.yml down