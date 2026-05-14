# Contributing — Module Interface Contract

Every module in this pack MUST follow this contract. No exceptions.

## Required Variables (every module)

```hcl
variable "project_name" {
  type        = string
  description = "Project identifier. Used in resource naming."
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,23}$", var.project_name))
    error_message = "Project name must be 3-24 lowercase alphanumeric chars or hyphens, starting with a letter."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group to deploy into."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}
```

## Required Outputs (every module)

```hcl
output "compliance_status" {
  description = "Map of SOC2 control_id to compliance evidence."
  value = {
    "CC6.X" = {
      control     = "CC6.X — Control name"
      status      = "COMPLIANT"
      resource_id = azurerm_some_resource.this.id
      evidence    = "Human-readable description of what was deployed and why it satisfies the control"
    }
  }
}
```

## Required Tags (every resource)

```hcl
locals {
  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "<your-module-name>"
    environment = var.environment
  })
}
```

## Rules

- Every variable MUST have a `validation {}` block (except `tags`)
- No hardcoded values — everything parameterised or from data sources
- Secure defaults — most restrictive option is the default
- `sensitive = true` on all secret outputs
- No wildcard (`*`) permissions
- README with usage, inputs table, outputs table, SOC2 controls

## Branching

```
feature/<module-name>    →  PR to dev
dev                      →  PR to main (after integration test)
```

## Commits

Use conventional commits: `feat:`, `fix:`, `chore:`, `ci:`, `docs:`

Reference issues: `Closes #N`
