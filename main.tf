locals {
  common_tags = merge(var.tags, {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    pack        = "zero-trust-compliance"
  })
}

# --- Resource Group ---

module "resource_group" {
  source = "./modules/resource-group"

  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  tags         = local.common_tags
}

# --- Module A: Secrets Rotation ---

module "secrets_rotation" {
  count  = var.enable_secrets_rotation ? 1 : 0
  source = "./modules/secrets-rotation"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.common_tags
  allowed_ips         = var.allowed_ips
}

# --- Module B: IAM Least-Privilege ---

module "iam_least_privilege" {
  count  = var.enable_iam_least_privilege ? 1 : 0
  source = "./modules/iam-least-privilege"

  project_name           = var.project_name
  environment            = var.environment
  location               = var.location
  resource_group_name    = module.resource_group.name
  tags                   = local.common_tags
  workload_principal_ids = var.workload_principal_ids
  reader_principal_ids   = var.reader_principal_ids
}

# --- Module C: KMS Encryption ---

module "kms_encryption" {
  count  = var.enable_kms_encryption ? 1 : 0
  source = "./modules/kms-encryption"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  key_vault_id        = var.enable_secrets_rotation ? module.secrets_rotation[0].key_vault_id : null
  tags                = local.common_tags
  allowed_ips         = var.allowed_ips
}

# --- Module D: Compliance Checks ---

module "compliance_checks" {
  count  = var.enable_compliance_checks ? 1 : 0
  source = "./modules/compliance-checks"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.common_tags
  key_vault_id        = var.enable_secrets_rotation ? module.secrets_rotation[0].key_vault_id : null
  key_vault_enabled   = var.enable_secrets_rotation
}

# --- Module E: VM Compliance (CIS Level 1) ---

module "vm_compliance" {
  count  = var.enable_vm_compliance ? 1 : 0
  source = "./modules/vm-compliance"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.common_tags
}

# --- State Moves ---
# Move the bare azurerm_resource_group resource into the new module.
# This is a one-time migration — safe to remove once applied.
moved {
  from = azurerm_resource_group.main
  to   = module.resource_group.azurerm_resource_group.this
}
