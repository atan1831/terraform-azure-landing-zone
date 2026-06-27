# Azure Secure Landing Zone — Terraform

Secure Azure Landing Zone implementiran s Terraformom kao dio cloud security portfolia.

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

## Kako pokrenuti

### Preduvjeti
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure free account

### Koraci

```bash
# 1. Login u Azure
az login

# 2. Dohvati Tenant ID
az account show --query tenantId -o tsv

# 3. Kopiraj i popuni varijable
cp terraform.tfvars.example terraform.tfvars
# Uredi terraform.tfvars — dodaj tenant_id

# 4. Inicijaliziraj Terraform
terraform init

# 5. Provjeri što će se kreirati
terraform plan

# 6. Deploy
terraform apply

# 7. Cleanup (ne troši kredite)
terraform destroy
```

## CI/CD Pipeline

GitHub Actions automatski radi na svakom push/PR:
- `terraform fmt` — provjera formatiranja
- `terraform validate` — sintaksna validacija
- `tfsec` — security scan IaC koda
- `Checkov` — compliance scan

## Što sam naučio

- Terraform moduli za reusable infrastrukturu
- NSG pravila s deny-all default pristupom (zero trust networking)
- Key Vault network ACL za zabranu javnog pristupa tajnama
- Activity Log alerting za kritične Azure operacije
- IaC security scanning u CI/CD piplineu (shift-left security)

## Screenshots

*(Dodaj screenshots iz Azure portala nakon deploymenta)*
- [ ] Resource Group u Azure portalu
- [ ] VNet s subnetovima
- [ ] NSG pravila
- [ ] Key Vault access policies
- [ ] Defender for Cloud dashboard
- [ ] GitHub Actions — zeleni workflow

---
*Dio [Azure Cloud Security Portfolio](https://github.com/tvoj-username) projekta*
