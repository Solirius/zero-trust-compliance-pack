output "storage_account_id" {
  description = "The ID of the secure storage account"
  value       = azurerm_storage_account.secure_storage.id
}

output "disk_encryption_set_id" {
  description = "The ID of the disk encryption set"
  value       = azurerm_disk_encryption_set.main.id
}

output "cmk_key_id" {
  description = "The ID of the CMK used for encryption"
  value       = azurerm_key_vault_key.cmk.id
}

output "compliance_status" {
  description = "SOC2 CC6.6 + CC6.7 Compliance Evidence"
  value = {
    "CC6.6" = {
      control     = "Encryption in Transit"
      status      = "COMPLIANT"
      resource_id = azurerm_storage_account.secure_storage.id
      evidence    = "TLS 1.2 enforced, HTTPS only enabled"
    }
    "CC6.7" = {
      control     = "Encryption at Rest"
      status      = "COMPLIANT"
      resource_id = azurerm_storage_account.secure_storage.id
      evidence    = "CMK (RSA-4096) with auto-rotation (30d) enabled for storage and disk encryption set"
    }
  }
}
