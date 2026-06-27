locals {
  common_tags = {
    project     = "azure-landing-zone"
    environment = var.environment
    owner       = "cloud-security-portfolio"
    managed_by  = "terraform"
  }
}
