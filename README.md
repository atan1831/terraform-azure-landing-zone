# Azure Secure Landing Zone — Terraform

Secure Azure Landing Zone implemented with terraform.

## Arhitektura

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

## Security principi implementirani

| Princip | Implementacija |
|---|---|
| Least privilege | NSG pravila: deny-all default, explicit allow |
| Secrets management | Key Vault s network ACL deny-all |
| Monitoring | Activity Log alert za kritične operacije |
| IaC Security | tfsec + Checkov u CI/CD piplineu |
| Tagging | Sve resursi tagovi: project, environment, managed_by |

## Struktura repozitorija

```
.
├── main.tf              # Root modul — orchestracija
├── variables.tf         # Input varijable
├── outputs.tf           # Output vrijednosti
├── locals.tf            # Lokalne varijable (tagovi)
├── terraform.tfvars.example
├── .gitignore           # Isključuje state i tfvars
├── .github/
│   └── workflows/
│       └── terraform-validate.yml   # CI: fmt, validate, tfsec, checkov
└── modules/
    ├── networking/      # VNet, subneti, NSG grupe
    ├── keyvault/        # Key Vault s access policy
    └── security/        # Defender for Cloud, Monitor alerts
```

## How to

### Whats needed
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure free account

### Steps

```bash
# 1. Login in Azure
az login

# 2. Fetch Tenant ID
az account show --query tenantId -o tsv

# 3. Copy and fill in
cp terraform.tfvars.example terraform.tfvars
# Modify terraform.tfvars — add ID's

# 4. Initiate terraform
terraform init

# 5. Check what is planned
terraform plan

# 6. Deploy
terraform apply

# 7. Cleanup
terraform destroy
```

## CI/CD Pipeline

GitHub Actions automatski radi na svakom push/PR:
- `terraform fmt` — format check
- `terraform validate` — sintax validiation
- `tfsec` — security scan IaC code
- `Checkov` — compliance scan

=======
