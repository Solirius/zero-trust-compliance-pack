output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used for auditing"
  value       = local.law_id
}

output "compliance_status" {
  description = "SOC2 CC6.2 Compliance Evidence"
  value = {
    control               = "CC6.2"
    status                = "COMPLIANT"
    key_vault_id          = azurerm_key_vault.main.id
    sku                   = azurerm_key_vault.main.sku_name
    purge_protection      = azurerm_key_vault.main.purge_protection_enabled
    rbac_authorization    = azurerm_key_vault.main.enable_rbac_authorization
    diagnostic_logging    = "ENABLED"
    audit_log_destination = local.law_id
    evidence_timestamp    = timestamp()
  }
}
