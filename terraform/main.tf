terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10.0"
    }
  }

  required_version = ">= 1.1.0"
}


provider "azurerm" {
  features {}
}

# Crear el grupo de recursos
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.location_name
}

# Crear la red virtual después de que se haya creado el grupo de recursos
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.acr_rg]
  name                = "cp2_vnet_name"
  address_space       = ["10.0.0.0/16"]
  location            = var.location_name
  resource_group_name = azurerm_resource_group.acr_rg.name
}




