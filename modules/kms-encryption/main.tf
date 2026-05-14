locals {
  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "kms-encryption"
    environment = var.environment
  })
}

resource "azurerm_key_vault_key" "cmk" {
  name         = "cmk-${var.project_name}-${var.environment}"
  key_vault_id = var.key_vault_id
  key_type     = "RSA-HSM" # Requirement says HSM-backed in Issue 2, assuming same here
  key_size     = 4096

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

  tags = local.module_tags
}

resource "azurerm_storage_account" "secure_storage" {
  name                     = "st${var.project_name}${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false # Force Azure AD auth

  identity {
    type = "SystemAssigned"
  }

  tags = local.module_tags
}

resource "azurerm_role_assignment" "storage_kv_access" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_storage_account.secure_storage.identity[0].principal_id
}

resource "azurerm_storage_account_customer_managed_key" "cmk" {
  storage_account_id = azurerm_storage_account.secure_storage.id
  key_vault_id       = var.key_vault_id
  key_name           = azurerm_key_vault_key.cmk.name

  depends_on = [azurerm_role_assignment.storage_kv_access]
}

resource "azurerm_disk_encryption_set" "main" {
  name                = "des-${var.project_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.cmk.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.module_tags
}

resource "azurerm_role_assignment" "des_kv_access" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.main.identity[0].principal_id
}
