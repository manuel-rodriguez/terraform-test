# Oxxo - DevSecOps - JoruneyToThecloud
 
# Creación del Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  tags                        = var.tags
}