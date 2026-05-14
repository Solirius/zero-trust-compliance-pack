output "compliance_report" {
  description = "Aggregated SOC2 compliance status from all enabled modules."
  value = merge(
    var.enable_secrets_rotation ? module.secrets_rotation[0].compliance_status : {},
    var.enable_iam_least_privilege ? module.iam_least_privilege[0].compliance_status : {},
    var.enable_kms_encryption ? module.kms_encryption[0].compliance_status : {},
    var.enable_compliance_checks ? module.compliance_checks[0].compliance_status : {},
    var.enable_vm_compliance ? module.vm_compliance[0].compliance_status : {},
  )
}

output "compliance_summary" {
  description = "Summary of enabled modules and control count."
  value = {
    total_controls = length(keys(merge(
      var.enable_secrets_rotation ? module.secrets_rotation[0].compliance_status : {},
      var.enable_iam_least_privilege ? module.iam_least_privilege[0].compliance_status : {},
      var.enable_kms_encryption ? module.kms_encryption[0].compliance_status : {},
      var.enable_compliance_checks ? module.compliance_checks[0].compliance_status : {},
      var.enable_vm_compliance ? module.vm_compliance[0].compliance_status : {},
    )))
    modules_enabled = {
      secrets_rotation    = var.enable_secrets_rotation
      iam_least_privilege = var.enable_iam_least_privilege
      kms_encryption      = var.enable_kms_encryption
      compliance_checks   = var.enable_compliance_checks
      vm_compliance       = var.enable_vm_compliance
    }
  }
}

output "key_vault_id" {
  description = "Key Vault resource ID (if secrets module enabled)."
  value       = var.enable_secrets_rotation ? module.secrets_rotation[0].key_vault_id : null
}

output "key_vault_uri" {
  description = "Key Vault URI (if secrets module enabled)."
  value       = var.enable_secrets_rotation ? module.secrets_rotation[0].key_vault_uri : null
}
