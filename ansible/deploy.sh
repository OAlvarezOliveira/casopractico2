#!/bin/bash

# Eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "20.68.151.93"

# Evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 20.68.151.93 >> ~/.ssh/known_hosts


# Lista de playbooks a ejecutar para la VM con Podman
#ansible-playbook -i hosts.txt 00_playbook.yml --extra-vars "@vars.yaml"
#ansible-playbook -i hosts.txt 01_playbook.yml --extra-vars "@vars.yaml"
#ansible-playbook -i hosts.txt 02_playbook.yml --extra-vars "@vars.yaml"

# Lista de playbooks a ejecutar para la AzureVote con Redis
 ansible-playbook -i hosts.txt 03_playbook.yml --extra-vars "@vars.yaml"  
 ansible-playbook -i hosts.txt 04_playbook.yml --extra-vars "@vars.yaml" 
