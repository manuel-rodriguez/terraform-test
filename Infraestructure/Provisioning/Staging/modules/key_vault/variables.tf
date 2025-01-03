variable "key_vault_name" {
  description = "Nombre del Azure Key Vault"
  type        = string
}
 
variable "location" {
  description = "Localización del recurso"
  type        = string
}
 
variable "resource_group_name" {
  description = "Nombre del grupo de recursos donde se creará el Key Vault"
  type        = string
}
 
variable "tenant_id" {
  description = "ID del tenant (Directorio de Azure)"
  type        = string
}
 
variable "sku_name" {
  description = "SKU de los servicios"
  type        = string
  default     = "standard"
}
 
variable "tags" {
  description = "Lista de tags para el Key Vault"
  type        = map(any)
  default     = {}
}