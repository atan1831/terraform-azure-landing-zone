# Azure Secure Landing Zone (Terraform)

Secure Azure Landing Zone implemented with Terraform.

## Architecture

```
Azure Subscription
└── Resource Group (sec-dev-rg)
    ├── Virtual Network (10.0.0.0/16)
    │   ├── app-subnet    (10.0.1.0/24) ← NSG: HTTPS only
    │   ├── data-subnet   (10.0.2.0/24)
    │   └── mgmt-subnet   (10.0.3.0/24) ← NSG: no internet
    ├── Key Vault (soft-delete, network ACL deny-all)
    ├── Network Watcher
    ├── Microsoft Defender for Cloud (free tier)
    └── Monitor Alerts (Key Vault delete alert)
```

## Security

| Principle | Implementation |
|---|---|
| Least privilege | NSG rules: deny-all by default, explicit allow |
| Secrets management | Key Vault with network ACL deny-all |
| Monitoring | Activity Log alert for critical operations |
| IaC Security | tfsec + Checkov in the CI/CD pipeline |
| Tagging | All resources tagged: project, environment, managed_by |

## Repository structure

```
.
├── main.tf              # Root module
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── locals.tf            # Local values (tags)
├── terraform.tfvars.example
├── .gitignore           # Excludes state and tfvars
├── .github/
│   └── workflows/
│       └── terraform-validate.yml   # CI: fmt, validate, tfsec, checkov
└── modules/
    ├── networking/      # VNet, subnets, NSGs
    ├── keyvault/        # Key Vault with access policy
    └── security/        # Defender for Cloud, Monitor alerts
```

## Getting started

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure free account

### Steps

```bash
# 1. Log in to Azure
az login

# 2. Get your Tenant ID
az account show --query tenantId -o tsv

# 3. Copy the example variables file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and add your IDs

# 4. Initialize Terraform
terraform init

# 5. Check the plan
terraform plan

# 6. Deploy
terraform apply

# 7. Cleanup
terraform destroy
```

## CI/CD Pipeline

GitHub Actions runs automatically on every push/PR:
- `terraform fmt`: format check
- `terraform validate`: syntax validation
- `tfsec`: IaC security scan
- `Checkov`: compliance scan

