variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "apim_name" {
  description = "Name of the API Management service"
  type        = string
}

variable "publisher_name" {
  description = "Name of the API publisher"
  type        = string
}

variable "publisher_email" {
  description = "Email of the API publisher"
  type        = string
}

variable "function_app_url" {
  description = "Function App URL"
  type        = string
}

variable "function_app_key" {
  description = "Function App key"
  type        = string
}

variable "function_backend_name" {
  description = "Name of the function backend in APIM"
  type        = string
}

variable "function_app_name" {
  description = "Name of the function App Name"
  type        = string
}

variable "function_api_name" {
  description = "Name of the function API Name"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
}