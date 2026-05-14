# Secrets Rotation Module

This module deploys a secure Azure Key Vault with automated rotation policies and diagnostic logging, satisfying SOC2 CC6.2 controls.

## Features
- **Key Vault Premium SKU**: Support for HSM-backed keys.
- **RBAC Authorization**: Fine-grained access control using Azure RBAC.
- **Network Isolation**: Default deny policy with bypass for trusted Azure services.
- **Data Protection**: Purge protection and soft-delete enabled.
- **Auditing**: AuditEvent and AllMetrics logged to Log Analytics.
- **Rotation**: Example key with automatic rotation policy.

## Usage

```hcl
module "secrets" {
  source = "./modules/secrets-rotation"

  project_name        = "myproject"
  environment         = "prod"
  location            = "West Europe"
  resource_group_name = "rg-myproject-prod"
  
  tags = {
    Owner = "Owen"
    SOC2  = "CC6.2"
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
| tags | Standard tags for all resources | `map(string)` | `{}` | no |
| log_analytics_workspace_id | Optional Log Analytics Workspace ID | `string` | `null` | no |
| key_vault_sku | Key Vault SKU (standard/premium) | `string` | `"premium"` | no |
| soft_delete_retention_days | Soft delete retention days | `number` | `90` | no |

## Outputs
| Name | Description |
|------|-------------|
| key_vault_id | The ID of the Key Vault |
| key_vault_uri | The URI of the Key Vault |
| compliance_status | SOC2 CC6.2 Compliance Evidence |

## SOC2 Compliance
| Control | Requirement | Implementation |
|---------|-------------|----------------|
| CC6.2 | Credentials & secrets protection | Premium Key Vault, RBAC, Encryption at rest |
| CC7.1 | Monitoring & Detection | Diagnostic logs to Log Analytics |
