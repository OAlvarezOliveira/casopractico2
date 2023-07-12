# Salida de direcciones IP
output "podman_public_ip" {
  value = azurerm_public_ip.public_ip_podman_vm.ip_address
}

output "worker_public_ip" {
  value = azurerm_public_ip.public_ip_worker_vm.ip_address
}

output "aks_cluster_node_count" {
  value = azurerm_kubernetes_cluster.aks_cluster.default_node_pool[0].node_count
}