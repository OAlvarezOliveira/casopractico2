output "registry_acr" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "registry_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "registry_acr" {
  value = azurerm_container_registry.acr.login_server
}

output "podman_vm" {
  value = azurerm_public_ip.public_ip.ip_address
}

