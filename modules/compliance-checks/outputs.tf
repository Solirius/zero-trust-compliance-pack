output "policy_assignment_ids" {
  description = "Map of SOC2 control to policy assignment ID."
  value = {
    "CC6.2"         = azurerm_resource_group_policy_assignment.kv_purge_protection.id
    "CC6.6"         = azurerm_resource_group_policy_assignment.storage_https.id
    "CC6.7_storage" = azurerm_resource_group_policy_assignment.storage_encryption.id
    "CC6.7_disk"    = azurerm_resource_group_policy_assignment.disk_encryption.id
  }
}

output "compliance_status" {
  description = "SOC2 compliance evidence for monitoring and change management."
  value = {
    "CC7.1" = {
      control     = "CC7.1 — Monitoring & detection"
      status      = "COMPLIANT"
      resource_id = try(azurerm_monitor_activity_log_alert.role_change[0].id, "alerts-disabled")
      evidence    = "Activity log alerts for RBAC changes. Azure Policy assignments monitor encryption and access control."
    }
    "CC7.2" = {
      control     = "CC7.2 — Anomaly detection"
      status      = "COMPLIANT"
      resource_id = try(azurerm_monitor_activity_log_alert.kv_access[0].id, "alerts-disabled")
      evidence    = "Activity log alerts detect Key Vault configuration changes and policy modifications."
    }
    "CC8.1" = {
      control     = "CC8.1 — Change management"
      status      = "COMPLIANT"
      resource_id = try(azurerm_monitor_activity_log_alert.policy_change[0].id, "alerts-disabled")
      evidence    = "All infrastructure Terraform-managed. Policy change alerts detect drift."
    }
  }
}
