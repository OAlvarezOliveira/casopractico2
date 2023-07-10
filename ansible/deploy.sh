#!/bin/bash

#eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "51.142.226.203"

#evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 51.142.226.203 >> ~/.ssh/known_hosts

# Lista de playbooks a ejecutar
ansible-playbook -i hosts.txt 01_playbook.yaml