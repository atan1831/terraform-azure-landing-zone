# Free tier on purpose: paid Defender plans cost money per resource and this is a lab.
resource "azurerm_security_center_subscription_pricing" "defender_vms" {
  #checkov:skip=CKV_AZURE_19:Free tier on purpose, lab cost
  #checkov:skip=CKV_AZURE_55:Free tier on purpose, lab cost
  tier          = "Free"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_storage" {
  #checkov:skip=CKV_AZURE_19:Free tier on purpose, lab cost
  #checkov:skip=CKV_AZURE_84:Free tier on purpose, lab cost
  tier          = "Free"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "defender_keyvault" {
  #checkov:skip=CKV_AZURE_19:Free tier on purpose, lab cost
  #checkov:skip=CKV_AZURE_87:Free tier on purpose, lab cost
  tier          = "Free"
  resource_type = "KeyVaults"
}

resource "azurerm_monitor_action_group" "security_alerts" {
  name                = "${var.prefix}-${var.environment}-security-ag"
  resource_group_name = var.resource_group_name
  short_name          = "sec-alert"

  email_receiver {
    name                    = "security-team"
    email_address           = var.security_contact_email
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_activity_log_alert" "key_vault_delete" {
  name                = "${var.prefix}-${var.environment}-kv-delete-alert"
  resource_group_name = var.resource_group_name
  scopes              = ["/subscriptions/${var.subscription_id}"]
  description         = "Alert when a Key Vault is deleted"

  criteria {
    operation_name = "Microsoft.KeyVault/vaults/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security_alerts.id
  }

  tags = var.tags
}
