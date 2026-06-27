output "resource_group_name" {
  description = "Naziv Resource Groupa"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID Virtual Networka"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Naziv Virtual Networka"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "IDs svih subnetova"
  value       = module.networking.subnet_ids
}

output "key_vault_uri" {
  description = "URI Key Vaulta"
  value       = module.keyvault.key_vault_uri
  sensitive   = true
}

output "key_vault_id" {
  description = "ID Key Vaulta"
  value       = module.keyvault.key_vault_id
}
