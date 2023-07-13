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

# Devuelve el certificado del cliente utilizado para la autenticación del clúster
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate
  sensitive = true  
  
}

# Devuelve la clave del cliente utilizada para la autenticación del clúster
output "client_key" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_key
  sensitive = true  
}

# Devuelve el certificado CA del clúster utilizado para la autenticación del clúster
output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].cluster_ca_certificate
  sensitive = true  
}

# Devuelve la contraseña utilizada para la autenticación del clúster
output "cluster_password" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].password
  sensitive = true  
}

# Devuelve el nombre de usuario utilizado para la autenticación del clúster
output "cluster_username" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].username
  sensitive = true  
}

# Devuelve el host del clúster de Kubernetes
output "host" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].host
  sensitive = true  
}

# Devuelve la configuración de kubeconfig del clúster en formato sin procesar
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true  
}
