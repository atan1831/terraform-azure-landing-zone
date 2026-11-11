variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "sec"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Sweden Central"
}

variable "tenant_id" {
  description = "Azure Tenant ID (from Entra ID)"
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR block for Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR blocks for subnets"
  type        = map(string)
  default = {
    app  = "10.0.1.0/24"
    data = "10.0.2.0/24"
    mgmt = "10.0.3.0/24"
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID (for Activity Log Alert scope)"
  type        = string
}

variable "security_contact_email" {
  description = "Email that receives the Key Vault delete alert"
  type        = string
}