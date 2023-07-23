#!/bin/bash

# Eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "20.77.97.18"

# Añade a known_hosts para evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 20.77.97.18 >> ~/.ssh/known_hosts

# Asegurate de que ansible/kubeconfig.yaml es el correcto
yes | az aks get-credentials --resource-group cp2_resource_group --name aks_cluster_kubernetes --file /mnt/d/Minhasse/Documents/Proyectos/casopractico2/ansible/kubeconfig.yaml --overwrite-existing

# Asegurate de que ~/.kube/config es el correcto
yes | az aks get-credentials --resource-group cp2_resource_group --name aks_cluster_kubernetes --file  ~/.kube/config --overwrite-existing

# Verificar y ajustar los permisos del archivo kubeconfig
chmod 600 ~/.kube/config

# Lista de playbooks a ejecutar para la VM con Podman
ansible-playbook -i hosts.txt 00_playbook.yml --extra-vars "@vars.yml"
ansible-playbook -i hosts.txt 01_playbook.yml --extra-vars "@vars.yml"
ansible-playbook -i hosts.txt 02_playbook.yml --extra-vars "@vars.yml"

# Lista de playbooks a ejecutar para la AzureVote con Redis
ansible-playbook -i hosts.txt 03_playbook.yml --extra-vars "@vars.yml"
ansible-playbook -i hosts.txt 04_playbook.yml --extra-vars "@vars.yml"

