module "apim" {
  source              = "./modules/apiManagement"
  resource_group_name = var.resource_group_name
  location            = var.location
  apim_id            = var.apim_id
  api_name           = var.api_name
  api_display_name   = var.api_display_name
  api_path           = var.api_path
  backend_name       = var.backend_name
  backend_service_url = var.backend_service_url
  openapi_spec_path  = var.openapi_spec_path
  product_id         = var.product_id
  tags               = var.tags
  api_oauth_server_name = var.api_oauth_server_name
}