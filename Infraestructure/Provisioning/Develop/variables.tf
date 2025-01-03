variable "location" {
  description = "Localización del recurso"
  type        = string
}
 
variable "resource_group_name" {
  description = "Nombre del grupo de recursos donde se creará el Key Vault"
  type        = string
}
 
variable "tags" {
  description = "Lista de tags para los recursos de iniciativa"
  type        = map(any)
  default     = {}
}

variable "apim_id" {
  description = "ID del API Management existente"
  type        = string
}

variable "api_name" {
  description = "Nombre del API"
  type        = string
}

variable "api_display_name" {
  description = "Nombre de visualización del API"
  type        = string
}

variable "api_path" {
  description = "Path base del API"
  type        = string
}

variable "backend_name" {
  description = "Nombre del backend"
  type        = string
}

variable "backend_service_url" {
  description = "URL del servicio backend"
  type        = string
}

variable "openapi_spec_path" {
  description = "Ruta al archivo de especificación OpenAPI"
  type        = string
}

variable "product_id" {
  description = "ID del producto en APIM"
  type        = string
}

variable "api_oauth_server_name" {
  description = "Nombre del servidor de autorización OAuth2"
  type        = string
}