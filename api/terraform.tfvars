resource_group_name   = "nombre-del-resource-group"
location             = "eastus2"
api_name             = "bit-gis-api"
backend_name         = "bit-gis-backend"
backend_service_url  = "https://tu-servicio-backend.com"
openapi_spec_path    = "./openapi.yml"  # ruta relativa a tu archivo OpenAPI
apim_id              = "/subscriptions/xxxx/resourceGroups/yyyy/providers/Microsoft.ApiManagement/service/nombre-apim"
tags = {
  Environment = "Development"
  Project     = "BIT GIS"
} 