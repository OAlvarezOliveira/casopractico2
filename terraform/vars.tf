# Establecer el nombre del grupo de recursos
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "cp2_resource_group"
}

# Establecer la ubicación del grupo de recursos
variable "location_name" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "uksouth"
}

# Establecer num del nodes del pool 
variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}