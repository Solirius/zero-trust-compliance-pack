# IAM Least-Privilege Module

Custom Azure RBAC role definitions enforcing zero-trust least-privilege access. No wildcards, no over-scoped built-in roles.

## SOC2 Controls

| Control | Description | Evidence |
|---|---|---|
| CC6.1 | Logical access security | Custom roles, zero wildcards, scoped to RG |
| CC6.3 | Restrict unauthorized access | `not_actions` deny blocks on dangerous operations |

## Roles

### Workload Operator
Read KV secrets, read/write blobs, read VMs and metrics. **Blocked:** role modification, RG deletion, KV purge, blob deletion, secret purge.

### Security Reader
Read-only across all resources including policy and security assessments. Zero write permissions.

## Usage

```hcl
module "iam" {
  source = "./modules/iam-least-privilege"

  environment         = "production"
  project_name        = "myproject"
  resource_group_name = azurerm_resource_group.main.name
  location            = "West Europe"

  workload_principal_ids = ["<sp-object-id>"]
  reader_principal_ids   = ["<auditor-object-id>"]
}
```

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| project_name | string | — | yes | Project identifier |
| environment | string | — | yes | Deployment environment |
| location | string | — | yes | Azure region |
| resource_group_name | string | — | yes | Target resource group |
| workload_principal_ids | list(string) | [] | no | SPs for workload role |
| reader_principal_ids | list(string) | [] | no | Principals for read-only |
| tags | map(string) | {} | no | Resource tags |

## Outputs

| Name | Description |
|---|---|
| workload_operator_role_id | Custom workload role resource ID |
| security_reader_role_id | Custom reader role resource ID |
| compliance_status | SOC2 compliance evidence (CC6.1, CC6.3) |
