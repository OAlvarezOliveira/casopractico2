#!/bin/bash

# Eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "20.26.197.104"

# Evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 20.26.197.104 >> ~/.ssh/known_hosts

# Lista de playbooks a ejecutar para la VM con Podman
ansible-playbook -i hosts.txt 00_playbook.yaml
ansible-playbook -i hosts.txt 01_playbook.yaml
ansible-playbook -i hosts.txt 02_playbook.yaml