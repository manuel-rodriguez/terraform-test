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

# CORS Policy
resource "azurerm_api_management_api_policy" "cors_policy" {
  api_name            = azurerm_api_management_api.service_api.name
  api_management_name = split("/", var.apim_id)[8]
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
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