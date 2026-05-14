data "azurerm_resource_group" "target" {
  name = var.resource_group_name
}

locals {
  scope = data.azurerm_resource_group.target.id

  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "vm-compliance"
    environment = var.environment
  })
}

# ============================================================
# Azure Policy — CIS Level 1 VM Checks (verified built-in IDs)
# ============================================================

# CIS 5.2.4 — SSH key authentication required
# Built-in: "Authentication to Linux machines should require SSH keys"
resource "azurerm_resource_group_policy_assignment" "ssh_key_auth" {
  name                 = "${var.project_name}-cis-ssh-keys"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/630c64f9-8b6b-4c64-b511-6544ceff6fd6"
  description          = "CIS 5.2.4: Authentication to Linux machines should require SSH keys."
  display_name         = "[CIS 5.2.4] SSH Key Authentication Required"
}

# CIS 1.4 — Restrict open network ports
# Built-in: "All network ports should be restricted on NSGs associated to your VM"
resource "azurerm_resource_group_policy_assignment" "restrict_open_ports" {
  name                 = "${var.project_name}-cis-fw-ports"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9daedab3-fb2d-461e-b861-71790eead4f6"
  description          = "CIS 1.4: Restrict open network ports on NSGs associated with VMs."
  display_name         = "[CIS 1.4] Restrict VM Network Ports"
}

# No passwordless remote login
# Built-in: "Audit Linux machines that allow remote connections from accounts without passwords"
resource "azurerm_resource_group_policy_assignment" "no_password_remote" {
  name                 = "${var.project_name}-cis-no-passwd"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea53dbee-c6c9-4f0e-9f9e-de0039b78023"
  description          = "CIS: Audit Linux VMs that allow remote connections from accounts without passwords."
  display_name         = "[CIS] No Passwordless Remote Login"
}

# VM Disk Encryption
# Built-in: "Virtual machines should encrypt temp disks, caches, and data flows"
resource "azurerm_resource_group_policy_assignment" "vm_disk_encryption" {
  name                 = "${var.project_name}-cis-disk-enc"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d"
  description          = "CIS: VMs should encrypt temp disks, caches, and data flows."
  display_name         = "[CIS] VM Disk Encryption"
}

# System updates required
# Built-in: "System updates should be installed on your machines"
resource "azurerm_resource_group_policy_assignment" "system_updates" {
  name                 = "${var.project_name}-cis-updates"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/86b3d65f-7626-441e-b690-81a8b71cff60"
  description          = "CIS: System updates should be installed on virtual machines."
  display_name         = "[CIS] System Updates Required"
}

# VM Monitoring Agent
# Built-in: "Virtual machines should have the Log Analytics agent installed"
resource "azurerm_resource_group_policy_assignment" "vm_monitoring_agent" {
  name                 = "${var.project_name}-cis-monitor"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a70ca396-0a34-413a-88e1-b956c1e683be"
  description          = "CIS: Virtual machines should have monitoring agent installed."
  display_name         = "[CIS] VM Monitoring Agent Required"
}
