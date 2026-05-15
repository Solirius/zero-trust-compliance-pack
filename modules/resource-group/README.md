# Resource Group Module

Creates the Azure Resource Group that hosts every other module in this pack. Centralised so naming, tagging, and location are consistent across the stack.

## Usage

```hcl
module "rg" {
  source = "./modules/resource-group"

  project_name = "myproject"
  environment  = "production"
  location     = "West Europe"

  tags = {
    team = "platform"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| `project_name` | string | — | yes | Project identifier (3-24 lowercase alphanumeric + hyphens) |
| `environment` | string | — | yes | `dev`, `staging`, or `production` |
| `location` | string | — | yes | Azure region |
| `tags` | map(string) | `{}` | no | Additional tags |

## Outputs

| Name | Description |
|---|---|
| `name` | Resource group name (e.g. `rg-myproject-production`) |
| `id` | Azure resource ID |
| `location` | Resource group location |

## Naming Convention

`rg-{project_name}-{environment}` — enforced by the module, not configurable.
