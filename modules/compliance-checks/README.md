# Compliance Checks Module

Azure Policy assignments mapped to SOC2 controls and activity log alerts for security monitoring.

## SOC2 Controls

| Control | Description | Evidence |
|---|---|---|
| CC7.1 | Monitoring & detection | Activity log alerts on RBAC changes |
| CC7.2 | Anomaly detection | Key Vault configuration change alerts |
| CC8.1 | Change management | IaC-managed, drift detection via policy alerts |

## Policy Assignments

| Policy | SOC2 | Effect |
|---|---|---|
| Storage encryption required | CC6.7 | Audit |
| HTTPS required for storage | CC6.6 | Audit |
| Key Vault purge protection | CC6.2 | Audit |
| Disk encryption required | CC6.7 | Audit |

## Usage

```hcl
module "compliance" {
  source = "./modules/compliance-checks"

  environment         = "production"
  project_name        = "myproject"
  resource_group_name = azurerm_resource_group.main.name
  location            = "West Europe"
  key_vault_id        = module.secrets.key_vault_id
}
```

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| project_name | string | — | yes | Project identifier |
| environment | string | — | yes | Deployment environment |
| location | string | — | yes | Azure region |
| resource_group_name | string | — | yes | Target resource group |
| key_vault_id | string | null | no | Key Vault ID to monitor |
| enable_activity_log_alerts | bool | true | no | Enable security alerts |
| tags | map(string) | {} | no | Resource tags |

## Outputs

| Name | Description |
|---|---|
| policy_assignment_ids | SOC2 control → policy assignment ID |
| compliance_status | SOC2 evidence (CC7.1, CC7.2, CC8.1) |

## After Apply

Trigger policy evaluation immediately:

```bash
az policy state trigger-scan --resource-group "<rg-name>" --no-wait
```
