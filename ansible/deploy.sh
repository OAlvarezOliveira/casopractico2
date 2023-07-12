#!/bin/bash

# Eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "20.254.94.254"

# Evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 20.254.94.254 >> ~/.ssh/known_hosts

# Lista de playbooks a ejecutar para la VM con Podman
ansible-playbook -i hosts.txt 00_playbook.yaml --extra-vars "@vars.yaml"
ansible-playbook -i hosts.txt 01_playbook.yaml --extra-vars "@vars.yaml"
ansible-playbook -i hosts.txt 02_playbook.yaml --extra-vars "@vars.yaml"
