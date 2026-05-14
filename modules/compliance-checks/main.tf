data "azurerm_resource_group" "target" {
  name = var.resource_group_name
}

locals {
  scope = data.azurerm_resource_group.target.id

  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "compliance-checks"
    environment = var.environment
  })
}

# ============================================================
# Azure Policy Assignments — mapped to SOC2 controls
# ============================================================

# CC6.7 — Storage accounts must use encryption
resource "azurerm_resource_group_policy_assignment" "storage_encryption" {
  name                 = "${var.project_name}-storage-enc"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
  description          = "SOC2 CC6.7: Storage accounts must use encryption at rest."
  display_name         = "[CC6.7] Storage Encryption Required"
}

# CC6.6 — Storage accounts must enforce HTTPS
resource "azurerm_resource_group_policy_assignment" "storage_https" {
  name                 = "${var.project_name}-storage-https"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  description          = "SOC2 CC6.6: Storage accounts must use HTTPS."
  display_name         = "[CC6.6] HTTPS Required for Storage"
}

# CC6.2 — Key Vault must have purge protection
resource "azurerm_resource_group_policy_assignment" "kv_purge_protection" {
  name                 = "${var.project_name}-kv-purge"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
  description          = "SOC2 CC6.2: Key Vault must have purge protection."
  display_name         = "[CC6.2] Key Vault Purge Protection"
}

# CC6.7 — Managed disks must be encrypted
resource "azurerm_resource_group_policy_assignment" "disk_encryption" {
  name                 = "${var.project_name}-disk-enc"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d"
  description          = "SOC2 CC6.7: Managed disks must use encryption."
  display_name         = "[CC6.7] Disk Encryption Required"
}

# ============================================================
# Activity Log Alerts — CC7.1, CC7.2, CC8.1
# ============================================================

resource "azurerm_monitor_action_group" "security" {
  count = var.enable_activity_log_alerts ? 1 : 0

  name                = "ag-${var.project_name}-security"
  resource_group_name = var.resource_group_name
  location            = "global"
  short_name          = "SecAlerts"
  tags                = local.module_tags
}

# CC8.1 — Policy assignment changes (drift detection)
resource "azurerm_monitor_activity_log_alert" "policy_change" {
  count = var.enable_activity_log_alerts ? 1 : 0

  name                = "alert-policy-change-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = [local.scope]
  description         = "SOC2 CC8.1: Alert on Azure Policy assignment changes."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Authorization/policyAssignments/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security[0].id
  }

  tags = local.module_tags
}

# CC7.1 — Role assignment changes
resource "azurerm_monitor_activity_log_alert" "role_change" {
  count = var.enable_activity_log_alerts ? 1 : 0

  name                = "alert-role-change-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = [local.scope]
  description         = "SOC2 CC7.1: Alert on RBAC role assignment changes."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Authorization/roleAssignments/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security[0].id
  }

  tags = local.module_tags
}

# CC7.2 — Key Vault configuration changes
resource "azurerm_monitor_activity_log_alert" "kv_access" {
  count = var.enable_activity_log_alerts && var.key_vault_enabled ? 1 : 0

  name                = "alert-kv-access-${var.project_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = [local.scope]
  description         = "SOC2 CC7.2: Alert on Key Vault configuration changes."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.KeyVault/vaults/write"
  }

  action {
    action_group_id = azurerm_monitor_action_group.security[0].id
  }

  tags = local.module_tags
}
