# Devuelve el nombre del grupo de recursos
output "resource_group" {
  value = azurerm_resource_group.acr_rg.name
}

# Devuelve la dirección IP pública de podmanVM
output "ip_address" {
  value = azurerm_public_ip.public_ip_podman_vm.ip_address
}

# Devuelve el nombre del clúster de Kubernetes
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}