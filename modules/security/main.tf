resource "azurerm_security_center_subscription_pricing" "defender_vms" {
  tier          = "Free"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_storage" {
  tier          = "Free"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "defender_keyvault" {
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
