variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "api_name" {
  description = "Name of the API in APIM"
  type        = string
}

variable "backend_name" {
  description = "Name of the backend service in APIM"
  type        = string
}

variable "backend_service_url" {
  description = "URL of the backend service"
  type        = string
}

variable "openapi_spec_path" {
  description = "Path to the OpenAPI specification file (yml)"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
}

variable "apim_id" {
  description = "ID of the existing API Management service"
  type        = string
}

variable "api_display_name" {
  description = "Display name of the API"
  type        = string
}

variable "api_path" {
  description = "Path of the API"
  type        = string
}

variable "product_id" {
  description = "ID of the product"
  type        = string
}