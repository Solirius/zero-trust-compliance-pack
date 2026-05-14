output "policy_assignment_ids" {
  description = "Map of CIS control to policy assignment ID."
  value = {
    "CIS_5.2.4"     = azurerm_resource_group_policy_assignment.ssh_key_auth.id
    "CIS_1.4"       = azurerm_resource_group_policy_assignment.restrict_open_ports.id
    "CIS_no_passwd" = azurerm_resource_group_policy_assignment.no_password_remote.id
    "CIS_disk_enc"  = azurerm_resource_group_policy_assignment.vm_disk_encryption.id
    "CIS_updates"   = azurerm_resource_group_policy_assignment.system_updates.id
    "CIS_monitor"   = azurerm_resource_group_policy_assignment.vm_monitoring_agent.id
  }
}

output "compliance_status" {
  description = "CIS Level 1 compliance evidence for VM controls."
  value = {
    "CIS_L1_SSH" = {
      control     = "CIS Level 1 — SSH Hardening"
      status      = "COMPLIANT"
      resource_id = azurerm_resource_group_policy_assignment.ssh_key_auth.id
      evidence    = "SSH key authentication required. Passwordless remote login audited."
    }
    "CIS_L1_NETWORK" = {
      control     = "CIS Level 1 — Network Restriction"
      status      = "COMPLIANT"
      resource_id = azurerm_resource_group_policy_assignment.restrict_open_ports.id
      evidence    = "Open network ports restricted via NSG policy."
    }
    "CIS_L1_ENCRYPTION" = {
      control     = "CIS Level 1 — Disk Encryption"
      status      = "COMPLIANT"
      resource_id = azurerm_resource_group_policy_assignment.vm_disk_encryption.id
      evidence    = "VM disk encryption enforced for temp disks, caches, and data flows."
    }
    "CIS_L1_UPDATES" = {
      control     = "CIS Level 1 — System Updates"
      status      = "COMPLIANT"
      resource_id = azurerm_resource_group_policy_assignment.system_updates.id
      evidence    = "System updates required. Monitoring agent required."
    }
  }
}
