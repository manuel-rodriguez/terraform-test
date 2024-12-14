output "apim_id" {
  value = azurerm_api_management.apim.id
}

output "apim_gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}

output "function_api_url" {
  value = "${azurerm_api_management.apim.gateway_url}/${azurerm_api_management_api.function_api.path}"
}