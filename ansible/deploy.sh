#!/bin/bash

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
