# KMS Encryption Module

This module enforces encryption at rest for storage accounts and disks using customer-managed keys (CMK) in Azure Key Vault, satisfying SOC2 CC6.6 and CC6.7 controls.

## Features
- **CMK Encryption**: RSA-4096 key in Key Vault for storage and disk encryption.
- **Auto-Rotation**: CMK has a 30-day pre-expiry rotation policy.
- **Secure Storage**: HTTPS only, TLS 1.2 minimum, and shared key access disabled (forcing Azure AD authentication).
- **Disk Encryption**: Disk Encryption Set linked to the CMK for virtual machine disk encryption.
- **Network Isolation**: Storage account public access is restricted.

## SOC2 Compliance
| Control | Requirement | Implementation |
|---------|-------------|----------------|
| CC6.6 | Encryption in Transit | TLS 1.2 minimum, HTTPS only |
| CC6.7 | Encryption at Rest | RSA-4096 CMK with auto-rotation |

## Usage

```hcl
module "kms" {
  source = "./modules/kms-encryption"

  project_name        = "ztcp"
  environment         = "dev"
  location            = "West Europe"
  resource_group_name = "rg-ztcp-dev"
  key_vault_id        = module.secrets.key_vault_id

  tags = {
    Owner = "Owen"
    SOC2  = "CC6.6, CC6.7"
  }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Project name for resource naming | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| key_vault_id | ID of the Key Vault to store the CMK | `string` | n/a | yes |
| tags | Standard tags for all resources | `map(string)` | `{}` | no |

## Outputs
| Name | Description |
|------|-------------|
| storage_account_id | The ID of the secure storage account |
| disk_encryption_set_id | The ID of the disk encryption set |
| cmk_key_id | The ID of the CMK used for encryption |
| compliance_status | SOC2 compliance evidence mapping |
