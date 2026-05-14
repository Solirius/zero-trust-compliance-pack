output "workload_operator_role_id" {
  description = "Resource ID of the custom workload operator role."
  value       = azurerm_role_definition.workload_operator.role_definition_resource_id
}

output "security_reader_role_id" {
  description = "Resource ID of the custom security reader role."
  value       = azurerm_role_definition.security_reader.role_definition_resource_id
}

output "compliance_status" {
  description = "SOC2 compliance evidence for IAM controls."
  value = {
    "CC6.1" = {
      control     = "CC6.1 — Logical access security"
      status      = "COMPLIANT"
      resource_id = azurerm_role_definition.workload_operator.role_definition_resource_id
      evidence    = "Custom RBAC roles with zero wildcard permissions. Workload operator and security reader scoped to resource group. ${length(var.workload_principal_ids)} workload principals, ${length(var.reader_principal_ids)} reader principals assigned."
    }
    "CC6.3" = {
      control     = "CC6.3 — Restrict unauthorized access"
      status      = "COMPLIANT"
      resource_id = azurerm_role_definition.workload_operator.role_definition_resource_id
      evidence    = "not_actions block: role modification, resource group deletion, Key Vault purge. not_data_actions block: secret purge, blob deletion."
    }
  }
}
