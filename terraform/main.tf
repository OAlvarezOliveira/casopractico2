terraform {
#Declaración de proveedores requeridos:  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.10.0"
    }
  }
#Versión requerida de Terraform:
  required_version = ">= 1.1.0"
}

#Declaración del proveedor "azurerm
provider "azurerm" {
  features {}
}

