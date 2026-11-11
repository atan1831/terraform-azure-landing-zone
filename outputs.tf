output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value       = module.networking.subnet_ids
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.keyvault.key_vault_uri
  sensitive   = true
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = module.keyvault.key_vault_id
}
