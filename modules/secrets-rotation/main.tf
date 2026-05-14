data "azurerm_client_config" "current" {}

locals {
  create_law = var.log_analytics_workspace_id == null
  law_id     = local.create_law ? azurerm_log_analytics_workspace.main[0].id : var.log_analytics_workspace_id

  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "secrets-rotation"
    environment = var.environment
  })
}

resource "azurerm_log_analytics_workspace" "main" {
  count               = local.create_law ? 1 : 0
  name                = "law-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.module_tags
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
  rbac_authorization_enabled  = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.allowed_ips
  }

  tags = local.module_tags
}

resource "azurerm_monitor_diagnostic_setting" "kv_audit" {
  name                       = "kv-audit-to-law"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = local.law_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
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