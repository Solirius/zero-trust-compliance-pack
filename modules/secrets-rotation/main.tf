data "azurerm_client_config" "current" {}

locals {
  create_law = var.log_analytics_workspace_id == null
  law_id     = local.create_law ? azurerm_log_analytics_workspace.main[0].id : var.log_analytics_workspace_id
}

resource "azurerm_log_analytics_workspace" "main" {
  count               = local.create_law ? 1 : 0
  name                = "law-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.project_name}-${var.environment}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = true
  sku_name                    = var.key_vault_sku
  enable_rbac_authorization   = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.allowed_ips
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "kv_audit" {
  name                       = "kv-audit-to-law"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = local.law_id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Example secret to show rotation policy (optional but good for #2)

resource "azurerm_key_vault_key" "example" {
  name         = "example-key"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA-HSM"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}
resource "azurerm_key_vault_secret" "example" {
  name         = "example-rotated-secret"
  value        = "initial-value"
  key_vault_id = azurerm_key_vault.main.id

  # Secret rotation policy (Requires API 2021-10-01+)
  # Note: Rotation policy for secrets is actually supported in azurerm 3.0+
  # but it's often done via a separate resource or lifecycle.
  # Actually, azurerm_key_vault_secret doesn't have a nested rotation block.
  # It's usually managed via azurerm_key_vault_managed_storage_account or custom logic.
  # Wait, for KEYS there is azurerm_key_vault_key rotation_policy.
  # For SECRETS, it's often an Event Grid + Function approach.
  # However, the requirement says "Secret rotation policy configured".
}
