variable "environment_name" {
  description = "Nombre del ambiente"
  type = string
}

variable "location" {
  description = "Location Resource Name"
 
}
 
variable "rg_name" {
  description = "Resource Group Name"
 
}
 
variable "tags" {
  description = "Etiquetas para la VM"
  type        = map(string)
  default     = {
    environment = "staging"
    owner       = "team-devops"
  }
}

