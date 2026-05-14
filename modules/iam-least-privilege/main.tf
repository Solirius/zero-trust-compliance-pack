data "azurerm_resource_group" "target" {
  name = var.resource_group_name
}

locals {
  scope = data.azurerm_resource_group.target.id

  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "iam-least-privilege"
    environment = var.environment
  })
}

# --- Custom Role: Workload Operator ---
# Zero wildcards. Every permission explicitly enumerated.
# not_actions blocks dangerous operations even if role is over-scoped.

resource "azurerm_role_definition" "workload_operator" {
  name        = "${var.project_name}-${var.environment}-workload-operator"
  scope       = local.scope
  description = "Least-privilege role for ${var.project_name} workloads. No wildcards, no delete on critical resources."

  permissions {
    actions = [
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.KeyVault/vaults/secrets/getSecret/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/instanceView/read",
      "Microsoft.Insights/metrics/read",
      "Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
    ]

    not_actions = [
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.KeyVault/vaults/delete",
      "Microsoft.KeyVault/vaults/purge/action",
    ]

    data_actions = [
      "Microsoft.KeyVault/vaults/secrets/getSecret/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    ]

    not_data_actions = [
      "Microsoft.KeyVault/vaults/secrets/purge/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
    ]
  }

  assignable_scopes = [local.scope]
}

# --- Custom Role: Security Reader ---
# Zero write permissions. For audit and compliance use only.

resource "azurerm_role_definition" "security_reader" {
  name        = "${var.project_name}-${var.environment}-security-reader"
  scope       = local.scope
  description = "Read-only role for audit and compliance. Zero write permissions."

  permissions {
    actions = [
      "Microsoft.KeyVault/vaults/read",
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/instanceView/read",
      "Microsoft.Insights/metrics/read",
      "Microsoft.Insights/diagnosticSettings/read",
      "Microsoft.Insights/logDefinitions/read",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleDefinitions/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Security/assessments/read",
      "Microsoft.PolicyInsights/policyStates/read",
    ]

    not_actions = []
  }

  assignable_scopes = [local.scope]
}

# --- Role Assignments: Workload Principals ---

resource "azurerm_role_assignment" "workload" {
  count = length(var.workload_principal_ids)

  scope              = local.scope
  role_definition_id = azurerm_role_definition.workload_operator.role_definition_resource_id
  principal_id       = var.workload_principal_ids[count.index]
  description        = "Least-privilege workload operator for ${var.project_name}"
}

# --- Role Assignments: Reader Principals ---

resource "azurerm_role_assignment" "reader" {
  count = length(var.reader_principal_ids)

  scope              = local.scope
  role_definition_id = azurerm_role_definition.security_reader.role_definition_resource_id
  principal_id       = var.reader_principal_ids[count.index]
  description        = "Security reader for audit and compliance"
}
