output "registry_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "registry_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "registry_acr" {
  value = azurerm_container_registry.acr.login_server
}

output "podman_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "worker_public_ip" {
  value = azurerm_public_ip.worker_public_ip.ip_address
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_location" {
  value = azurerm_kubernetes_cluster.aks_cluster.location
}

output "aks_cluster_dns_prefix" {
  value = azurerm_kubernetes_cluster.aks_cluster.dns_prefix
}

output "aks_cluster_rg_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.resource_group_name
}

output "aks_cluster_node_count" {
  value = azurerm_kubernetes_cluster.aks_cluster.default_node_pool.node_count
}
