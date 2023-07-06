output "acr_admin_pass" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "acr_admin_user" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "ssh_user" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}

output "vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

