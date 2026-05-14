output "policy_assignment_ids" {
  description = "Map of CIS benchmark control to policy assignment ID."
  value = {
    "CIS_5.2.1_ssh_config"   = azurerm_resource_group_policy_assignment.ssh_config_permissions.id
    "CIS_5.2.4_ssh_key_auth" = azurerm_resource_group_policy_assignment.ssh_key_auth.id
    "CIS_1.4_restrict_ports" = azurerm_resource_group_policy_assignment.restrict_open_ports.id
    "CIS_no_passwd_remote"   = azurerm_resource_group_policy_assignment.no_password_remote.id
    "CIS_6.2.1_no_empty_pw"  = azurerm_resource_group_policy_assignment.no_empty_passwords.id
    "CIS_disk_encryption"    = azurerm_resource_group_policy_assignment.vm_disk_encryption.id
    "CIS_antimalware"        = azurerm_resource_group_policy_assignment.antimalware_updates.id
    "CIS_monitoring_agent"   = azurerm_resource_group_policy_assignment.vm_monitoring_agent.id
    "CIS_system_updates"     = azurerm_resource_group_policy_assignment.system_updates.id
  }
}

output "compliance_status" {
  description = "CIS Level 1 VM compliance evidence for SOC2 reporting."
  value = {
    "CIS_L1_SSH" = {
      control     = "CIS Level 1 — SSH Hardening (5.2.1, 5.2.4)"
      status      = "ENFORCED"
      resource_id = azurerm_resource_group_policy_assignment.ssh_key_auth.id
      evidence    = "SSH config permissions (0600) and key-only authentication enforced via Azure Policy."
    }
    "CIS_L1_FIREWALL" = {
      control     = "CIS Level 1 — Firewall / Network Ports (1.4)"
      status      = "ENFORCED"
      resource_id = azurerm_resource_group_policy_assignment.restrict_open_ports.id
      evidence    = "All network ports restricted on NSGs associated with VMs."
    }
    "CIS_L1_AUTH" = {
      control     = "CIS Level 1 — Authentication (6.2.1)"
      status      = "AUDITED"
      resource_id = azurerm_resource_group_policy_assignment.no_empty_passwords.id
      evidence    = "Audit policies detect VMs with empty passwords or passwordless remote access."
    }
    "CIS_L1_ENCRYPTION" = {
      control     = "CIS Level 1 — Disk Encryption"
      status      = "ENFORCED"
      resource_id = azurerm_resource_group_policy_assignment.vm_disk_encryption.id
      evidence    = "VM disk encryption policy enforced for temp disks, caches, and storage."
    }
    "CIS_L1_ENDPOINT" = {
      control     = "CIS Level 1 — Endpoint Protection"
      status      = "ENFORCED"
      resource_id = azurerm_resource_group_policy_assignment.antimalware_updates.id
      evidence    = "Antimalware signature auto-update enforced. Monitoring agent and system updates required."
    }
  }
}
