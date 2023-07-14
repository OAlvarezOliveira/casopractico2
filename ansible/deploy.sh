#!/bin/bash

# Eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "51.11.32.202"

# Evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 51.11.32.202 >> ~/.ssh/known_hosts

# Asegurate de que ansible/kubeconfig.yaml es el correcto
az aks get-credentials --resource-group cp2_resource_group --name aks_cluster_kubernetes --file /mnt/d/Minhasse/Documents/Proyectos/casopractico2/ansible/kubeconfig.yaml

# Asegurate de que ~/.kube/config es el correcto
az aks get-credentials --resource-group cp2_resource_group --name aks_cluster_kubernetes --file  ~/.kube/config

# Lista de playbooks a ejecutar para la VM con Podman
ansible-playbook -i hosts.txt 00_playbook.yml --extra-vars "@vars.yml"
ansible-playbook -i hosts.txt 01_playbook.yml --extra-vars "@vars.yml"
ansible-playbook -i hosts.txt 02_playbook.yml --extra-vars "@vars.yml"

# Lista de playbooks a ejecutar para la AzureVote con Redis
ansible-playbook -i hosts.txt 03_playbook.yml --extra-vars "@vars.yml"  

