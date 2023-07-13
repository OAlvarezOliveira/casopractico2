# Devuelve el nombre del grupo de recursos
output "resource_group_name" {
  value = azurerm_resource_group.acr_rg.name
}

# Devuelve el la IP Publica de podmanVM
output "podman_public_ip" {
  value = azurerm_public_ip.public_ip_podman_vm.ip_address
}

# Devuelve el nombre del clúster de Kubernetes
output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}
