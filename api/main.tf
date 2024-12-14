resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name           = "Developer_1"

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, { Uso = "API Management" })
}

# Function App API
resource "azurerm_api_management_api" "function_api" {
  name                = var.function_api_name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Function API"
  path                = "function"
  protocols           = ["https"]

}

# Backend Configuration
resource "azurerm_api_management_backend" "function_backend" {
  name                = var.function_backend_name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  protocol            = "http"
  url                = "https://${var.function_app_url}"

  credentials {
    header = {
      "x-functions-key" = var.function_app_key
    }
  }
}

# CORS Policy
resource "azurerm_api_management_api_policy" "cors_policy" {
  api_name            = azurerm_api_management_api.function_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <cors>
      <allowed-origins>
        <origin>*</origin>
      </allowed-origins>
      <allowed-methods>
        <method>POST</method>
      </allowed-methods>
      <allowed-headers>
        <header>*</header>
      </allowed-headers>
    </cors>
    <base />
  </inbound>
</policies>
XML
}

# API Operations

# Operation: ack
resource "azurerm_api_management_api_operation" "ack" {
  operation_id        = "ack"
  api_name            = azurerm_api_management_api.function_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Acknowledge"
  method              = "POST"
  url_template        = "/api/ack"
  description         = "Acknowledge operation"

  request {
    representation {
      content_type = "application/json"
    }
  }

  response {
    status_code = 200
    representation {
      content_type = "application/json"
    }
  }
}

# Operation: list
resource "azurerm_api_management_api_operation" "list" {
  operation_id        = "list"
  api_name            = azurerm_api_management_api.function_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "List"
  method              = "POST"
  url_template        = "/api/list"
  description         = "List operation"

  request {
    representation {
      content_type = "application/json"
    }
  }

  response {
    status_code = 200
    representation {
      content_type = "application/json"
    }
  }
}

# Operation: outbound
resource "azurerm_api_management_api_operation" "outbound" {
  operation_id        = "outbound"
  api_name            = azurerm_api_management_api.function_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Outbound"
  method              = "POST"
  url_template        = "/api/outbound"
  description         = "Outbound operation"

  request {
    representation {
      content_type = "application/json"
    }
  }

  response {
    status_code = 200
    representation {
      content_type = "application/json"
    }
  }
}