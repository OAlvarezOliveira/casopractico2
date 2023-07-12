# Sección General

# Crear el grupo de recursos
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.location_name
}

# Crear la red virtual después de que se haya creado el grupo de recursos
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.acr_rg]
  name                = "vnet"
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

# Registro de contenedores de Azure utilizando el servicio ACR acceso público y autenticación
resource "azurerm_container_registry" "acr" {
  name                = "maseiraacr"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Sección PodmanVM

# Interfaz de red para PodmanVM
resource "azurerm_network_interface" "nic_podman_vm" {
  name                = "podmanVM_nic"
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name

  ip_configuration {
    name                          = "config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    # Asociar la dirección IP pública a la interfaz de red
    public_ip_address_id = azurerm_public_ip.public_ip_podman_vm.id
  }
}

# Dirección IP pública para PodmanVM
resource "azurerm_public_ip" "public_ip_podman_vm" {
  name                = "podmanVM_public_ip"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  allocation_method   = "Static"
}

# Máquina virtual para PodmanVM
resource "azurerm_linux_virtual_machine" "vm_podman_vm" {
  name                = "podmanVM"
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/server_admin/.ssh/id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nic_podman_vm.id,
  ]

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

# Sección WorkerAKS

# Interfaz de red para workerVM
resource "azurerm_network_interface" "nic_worker_vm" {
  name                = "workerVM_nic"
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name

  ip_configuration {
    name                          = "config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    # Asociar la dirección IP pública a la interfaz de red
    public_ip_address_id = azurerm_public_ip.public_ip_worker_vm.id
  }
}

# Dirección IP pública para workerVM
resource "azurerm_public_ip" "public_ip_worker_vm" {
  name                = "workerVM_public_ip"
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  allocation_method   = "Static"
}

# Máquina virtual para workerVM
resource "azurerm_linux_virtual_machine" "vm_worker_vm" {
  name                = "workerVm"
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/server_admin/.ssh/id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nic_worker_vm.id,
  ]

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

# Sección AKS 

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
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }
}