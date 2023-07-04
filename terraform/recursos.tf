resource "azurerm_subnet" "subnet" {
  name                 = "cp2_subnet_name"
  resource_group_name  = azurerm_resource_group.acr_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "cp2_nic_name"
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name

  ip_configuration {
    name                          = "cp2_nic_config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "cp2_vm_name"
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  size                = "Standard_DS1_v2"
  computer_name       = "cp2VM"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_username = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/server_admin/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks_cluster_name"
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name
  dns_prefix          = "aks-dns-prefix"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
  }
}
