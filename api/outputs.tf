output "api_url" {
  value = "${data.azurerm_api_management.existing.gateway_url}/${azurerm_api_management_api.service_api.path}"
}