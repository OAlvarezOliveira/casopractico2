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