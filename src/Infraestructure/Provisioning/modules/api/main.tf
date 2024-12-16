# Add this at the beginning of your main.tf
data "azurerm_api_management" "existing" {
  name                = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name
}

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
    content_value  = file("${path.module}/${var.openapi_spec_path}")
  }

  oauth2_authorization {
    authorization_server_name = "oauth-mers"
  }

}

# Backend Configuration with lifecycle ignore_changes
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

  lifecycle {
    ignore_changes = all
  }
}

# CORS Policy at API level
resource "azurerm_api_management_api_policy" "cors_policy" {
  api_name            = azurerm_api_management_api.service_api.name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name

  xml_content = templatefile("${path.module}/policies/api_policy.xml", {})
}

# Operation level policy
resource "azurerm_api_management_api_operation_policy" "put_operation_policy" {
  api_name            = azurerm_api_management_api.service_api.name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name
  operation_id        = "putUpdateFeaturesProcessing"

  xml_content = templatefile("${path.module}/policies/operation_policy.xml", {
    backend_name = var.backend_name
  })
}

# Import para el backend
import {
  to = azurerm_api_management_backend.service_backend
  id = "${var.apim_id}/backends/${var.backend_name}"
}

# Import para el API
import {
  to = azurerm_api_management_api.service_api
  id = "${var.apim_id}/apis/${var.api_name};rev=1"
}

# Import para la política a nivel API
import {
  to = azurerm_api_management_api_policy.cors_policy
  id = "${var.apim_id}/apis/${var.api_name}"
}

# Import para la política a nivel operación
import {
  to = azurerm_api_management_api_operation_policy.put_operation_policy
  id = "${var.apim_id}/apis/${var.api_name}/operations/putUpdateFeaturesProcessing"
}

# Asociación del API al producto
resource "azurerm_api_management_product_api" "product_api" {
  api_name            = azurerm_api_management_api.service_api.name
  product_id          = var.product_id
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name
}
