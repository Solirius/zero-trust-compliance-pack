resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

locals {
  common_tags = merge(var.tags, {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    pack        = "zero-trust-compliance"
  })
}

# --- Module A: Secrets Rotation ---

module "secrets_rotation" {
  count  = var.enable_secrets_rotation ? 1 : 0
  source = "./modules/secrets-rotation"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
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
  resource_group_name    = azurerm_resource_group.main.name
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
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# --- Module D: Compliance Checks ---

module "compliance_checks" {
  count  = var.enable_compliance_checks ? 1 : 0
  source = "./modules/compliance-checks"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
  key_vault_id        = var.enable_secrets_rotation ? module.secrets_rotation[0].key_vault_id : null
}
