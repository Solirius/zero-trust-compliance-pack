# VM Compliance — CIS Level 1 Benchmark Checks

Azure Policy assignments implementing CIS Level 1 benchmark controls for virtual machines.

## Controls

| CIS Control | Policy | Mode |
|---|---|---|
| 5.2.1 — SSH config permissions (0600) | Guest configuration | Audit |
| 5.2.4 — SSH key authentication required | Built-in policy | Audit |
| 1.4 — Restrict open network ports | NSG port restriction | Audit |
| 6.2.1 — No empty passwords | Guest configuration | Audit |
| — No passwordless remote login | Guest configuration | Audit |
| — VM disk encryption | Built-in policy | Audit |
| — Antimalware signature updates | Built-in policy | Audit |
| — Monitoring agent installed | Built-in policy | Audit |
| — System updates installed | Built-in policy | Audit |

## Prerequisites

Set `enable_guest_configuration = true` (default) to deploy the Guest Configuration extension prerequisite initiative, which is required for OS-level audit policies to evaluate.

## Usage

```hcl
module "vm_compliance" {
  source = "./modules/vm-compliance"

  project_name        = "ztcp"
  environment         = "dev"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}
```
