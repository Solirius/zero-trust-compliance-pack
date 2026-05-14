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
  description = "SOC2 compliance evidence for secret management."
  value = {
    "CC6.2" = {
      control     = "CC6.2 — Credentials & secrets"
      status      = "COMPLIANT"
      resource_id = azurerm_key_vault.main.id
      evidence    = "Key Vault ${azurerm_key_vault.main.sku_name} SKU, RBAC auth, purge protection, soft-delete ${var.soft_delete_retention_days} days, default-deny network ACLs, audit logging to Log Analytics."
    }
  }
}
