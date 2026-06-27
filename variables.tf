variable "prefix" {
  description = "Prefix za sve resurse (npr. tvoje inicijale)"
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
  default     = "West Europe"
}

variable "tenant_id" {
  description = "Azure Tenant ID (iz Entra ID)"
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR blok za Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR blokovi za subnetove"
  type        = map(string)
  default = {
    app  = "10.0.1.0/24"
    data = "10.0.2.0/24"
    mgmt = "10.0.3.0/24"
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID (za Activity Log Alert scope)"
  type        = string
  default     = ""
}