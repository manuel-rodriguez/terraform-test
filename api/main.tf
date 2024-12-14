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

  oauth2_authorization {
    authorization_server_name = "oauth-mers"
  }
}

# Check if backend exists using try/catch
locals {
  existing_backend = try(
    data.azurerm_api_management_backend.existing_backend[0].name,
    var.backend_name
  )
}

# Backend data source
data "azurerm_api_management_backend" "existing_backend" {
  count               = 1
  name                = var.backend_name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_api_management_backend.service_backend]
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

# CORS Policy at API level
resource "azurerm_api_management_api_policy" "cors_policy" {
  api_name            = azurerm_api_management_api.service_api.name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <validate-content unspecified-content-type-action="prevent" max-size="102400" size-exceeded-action="prevent" errors-variable-name="requestBodyValidation">
            <content type="application/json" validate-as="json" action="prevent" allow-additional-properties="false" />
        </validate-content>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

# Operation level policy using dynamic backend_id
resource "azurerm_api_management_api_operation_policy" "put_operation_policy" {
  api_name            = azurerm_api_management_api.service_api.name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name
  operation_id        = "putUpdateFeaturesProcessing"

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-header name="Authorization" exists-action="override">
            <value />
        </set-header>
        <set-backend-service backend-id="${local.existing_backend}" />
        <rewrite-uri template="/puntopotencial" />
        <set-method>POST</set-method>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}