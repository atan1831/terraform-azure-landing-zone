data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  #checkov:skip=CKV_AZURE_110:lab is destroyed after every session, purge protection would block purge on destroy
  #checkov:skip=CKV_AZURE_42:same as above, recoverable requires purge protection
  #checkov:skip=CKV2_AZURE_32:no private endpoint in this lab, public network access is disabled instead
  name                          = "${var.prefix}-${var.environment}-kv-${random_string.suffix.result}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = true
  tenant_id                     = var.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []
  }

  tags = var.tags
}

# RBAC instead of access policies, so vault access shows up in IAM like everything else
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
