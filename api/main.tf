# API from OpenAPI specification
resource "azurerm_api_management_api" "service_api" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = split("/", var.apim_id)[8]
  revision            = "1"
  display_name        = var.api_display_name
  path                = var.api_path 
  protocols           = ["https"]
  service_url         = var.backend_service_url
  subscription_required = true
  
  subscription_key_parameter_names {
    header = "x-Gateway-APIKey"
    query  = "subscription-key"
  }
  
  import {
    content_format = "openapi"
    content_value  = file(var.openapi_spec_path)
  }
}

# Unified Policy (OAuth2 + CORS)
resource "azurerm_api_management_api_policy" "api_policy" {
  api_name            = azurerm_api_management_api.service_api.name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <validate-oauth2-token authorization-server="oauth_mers" />
    <cors>
      <allowed-origins>
        <origin>*</origin>
      </allowed-origins>
      <allowed-methods>
        <method>PUT</method>
      </allowed-methods>
      <allowed-headers>
        <header>*</header>
      </allowed-headers>
    </cors>
    <base />
  </inbound>
</policies>
XML

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [azurerm_api_management_api.service_api]
  }

  # Bloque de migración usando variables
  provisioner "local-exec" {
    command = "terraform import azurerm_api_management_api_policy.api_policy '/subscriptions/${split("/", var.apim_id)[2]}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ApiManagement/service/${split("/", var.apim_id)[8]}/apis/${var.api_name}'"
  }
}

# Backend Configuration 
resource "azurerm_api_management_backend" "service_backend" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = split("/", var.apim_id)[8]
  protocol            = "http"
  url                = var.backend_service_url

  tls {
    validate_certificate_chain = true
    validate_certificate_name  = true
  }
}

data "azurerm_api_management" "existing" {
  name                = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name
}