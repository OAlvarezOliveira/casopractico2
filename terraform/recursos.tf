# Establecer el nombre del grupo de recursos
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "cp2_resource_group"
}

# Establecer el ubicación del grupo de recursos
variable "location_name" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "uksouth"
}

# Sección General

# Crear el grupo de recursos
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.location_name
}

# Crear la red virtual después de que se haya creado el grupo de recursos
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.acr_rg]
  name                = "cp2_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
}

# Subred en la red virtual
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.acr_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}


# Sección PodmanVM

# Interfaz de red
resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name

  ip_configuration {
    name                          = "config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    # Asociar la dirección IP pública a la interfaz de red
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Registro de contenedores de Azure utilizando el servicio ACR acceso público y autenticación 
resource "azurerm_container_registry" "acr" {
  name                = "maseiraACR"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Dirección IP pública para PodmanVM
resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip_podmanVm"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  allocation_method   = "Static"
}

# Maquina virtual Linux en Azure (PodmanVM)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "podmanVm"
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  size                = "Standard_DS1_v2"
  computer_name       = "podmanVm"

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
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }
}


# Sección AKS y Worker

# Cluster de Kubernetes administrado por Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks_cluster_kubernetes"
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

  identity {
    type = "SystemAssigned"
  }
}

# Dirección IP pública para el worker VM
resource "azurerm_public_ip" "worker_public_ip" {
  name                = "public_ip_worker_vm"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  allocation_method   = "Static"
}

# Máquina virtual para el worker
resource "azurerm_virtual_machine" "worker_vm" {
  name                = "aks-worker-vm"
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  size                = "Standard_DS1_v2"
  computer_name       = "aks-worker-vm"

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
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }
}

# Asociar la dirección IP pública al worker VM
resource "azurerm_network_interface" "worker_nic" {
  name                = "worker_nic"
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name

  ip_configuration {
    name                          = "worker_config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    # Asociar la dirección IP pública al worker NIC
    public_ip_address_id = azurerm_public_ip.worker_public_ip.id
  }
}

# Añadir el worker al grupo de nodos del clúster de AKS
resource "azurerm_kubernetes_cluster_node_pool" "aks_node_pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  name                  = "worker-pool"
  vm_size               = "Standard_DS1_v2"
  enable_auto_scaling   = true
  min_count             = 1
  max_count             = 5
}
