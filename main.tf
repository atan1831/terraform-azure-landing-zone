terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location

  tags = local.common_tags
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.prefix
  environment         = var.environment
  vnet_address_space  = var.vnet_address_space
  subnet_prefixes     = var.subnet_prefixes
  tags                = local.common_tags
}

module "keyvault" {
  source              = "./modules/keyvault"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.prefix
  environment         = var.environment
  tenant_id           = var.tenant_id
  tags                = local.common_tags
}

module "security" {
  source                 = "./modules/security"
  resource_group_name    = azurerm_resource_group.main.name
  location               = var.location
  prefix                 = var.prefix
  environment            = var.environment
  subscription_id        = var.subscription_id
  security_contact_email = var.security_contact_email
  tags                   = local.common_tags
}
