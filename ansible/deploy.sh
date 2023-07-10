#!/bin/bash

#eliminar una clave de host específica del archivo known_hosts
ssh-keygen -f "/home/server_admin/.ssh/known_hosts" -R "13.87.77.196"

#evitar la verificación del fingerprint al conectarte a ese host
ssh-keyscan -H 13.87.77.196 >> ~/.ssh/known_hosts


# Lista de playbooks a ejecutar
playbooks=("01_playbook.yaml" "02_playbook.yaml")

# Ruta al inventario de Ansible
inventory="hosts.txt"

# Recorre la lista de playbooks y ejecútalos
for playbook in "${playbooks[@]}"
do
    echo "Ejecutando playbook: $playbook"
    ansible-playbook -i "$inventory" -l podman_vm "$playbook"
    echo "Playbook $playbook completado"
done
