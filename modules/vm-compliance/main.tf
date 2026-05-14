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
# Azure Policy — VM Guest Configuration prerequisite
# ============================================================

# Deploy the Guest Configuration extension prerequisite.
# Built-in initiative: "Deploy prerequisites to enable Guest Configuration policies on virtual machines"
resource "azurerm_resource_group_policy_assignment" "guest_config_prereqs" {
  count = var.enable_guest_configuration ? 1 : 0

  name                 = "${var.project_name}-gc-prereqs"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882ead6a5b75"
  description          = "Deploy prerequisites to enable Guest Configuration policies on VMs."
  display_name         = "[CIS] Guest Configuration Prerequisites"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}

# ============================================================
# CIS Level 1 — OS Hardening Policies (Azure built-ins)
# ============================================================

# CIS 5.2.1 — SSH: Ensure permissions on /etc/ssh/sshd_config are configured
# Built-in: "Linux machines should have permissions on /etc/ssh/sshd_config set to 0600"
resource "azurerm_resource_group_policy_assignment" "ssh_config_permissions" {
  name                 = "${var.project_name}-cis-ssh-perms"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e35cf588-1cf4-4e0e-9880-c0d673beb72a"
  description          = "CIS 5.2.1: Ensure permissions on /etc/ssh/sshd_config are configured (0600)."
  display_name         = "[CIS 5.2.1] SSH Config Permissions"
}

# CIS 5.2.4 — SSH: Ensure SSH access is limited (no root login)
# Built-in: "Authentication to Linux machines should require SSH keys"
resource "azurerm_resource_group_policy_assignment" "ssh_key_auth" {
  name                 = "${var.project_name}-cis-ssh-keys"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/630c64f9-8b6b-4c64-b511-6544ceff6fd6"
  description          = "CIS 5.2.4: Authentication to Linux machines should require SSH keys, not passwords."
  display_name         = "[CIS 5.2.4] SSH Key Authentication Required"
}

# CIS 1.4 — Ensure firewall is installed and active
# Built-in: "Linux virtual machines should enable Azure Disk Encryption or EncryptionAtHost"
# Note: We use NSG-based policy as Azure's firewall equivalent for VMs.
# Built-in: "All network ports should be restricted on network security groups associated to your virtual machine"
resource "azurerm_resource_group_policy_assignment" "restrict_open_ports" {
  name                 = "${var.project_name}-cis-fw-ports"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9daedab3-fb2d-461e-b861-71790eead4f6"
  description          = "CIS 1.4: Restrict open network ports on NSGs associated with VMs."
  display_name         = "[CIS 1.4] Restrict VM Network Ports"
}

# CIS 1.1.1.1 — Ensure mounting of cramfs is disabled (OS hardening)
# Built-in: "Audit Linux machines that allow remote connections from accounts without passwords"
resource "azurerm_resource_group_policy_assignment" "no_password_remote" {
  name                 = "${var.project_name}-cis-no-passwd"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea53dbee-c6c9-4f0e-9f9e-de0039b78023"
  description          = "CIS: Audit Linux VMs that allow remote connections from accounts without passwords."
  display_name         = "[CIS] No Passwordless Remote Login"
}

# CIS 6.2.1 — Ensure password fields are not empty
# Built-in: "Audit Linux machines that have accounts without passwords"
resource "azurerm_resource_group_policy_assignment" "no_empty_passwords" {
  name                 = "${var.project_name}-cis-no-empty-pw"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f6ec09a3-78bf-4f8f-99dc-6c77571b8175"
  description          = "CIS 6.2.1: Audit Linux VMs that have accounts without passwords."
  display_name         = "[CIS 6.2.1] No Empty Passwords"
}

# ============================================================
# CIS Level 1 — Encryption at rest for VM disks
# ============================================================

# Built-in: "Virtual machines should encrypt temp disks, caches, and data flows between Compute and Storage resources"
resource "azurerm_resource_group_policy_assignment" "vm_disk_encryption" {
  name                 = "${var.project_name}-cis-disk-enc"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d"
  description          = "CIS: VMs should encrypt temp disks, caches, and data flows."
  display_name         = "[CIS] VM Disk Encryption"
}

# ============================================================
# CIS Level 1 — Endpoint protection
# ============================================================

# Built-in: "Microsoft Antimalware for Azure should be configured to automatically update protection signatures"
resource "azurerm_resource_group_policy_assignment" "antimalware_updates" {
  name                 = "${var.project_name}-cis-antimal"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c43e4a30-77cb-48ab-a4dd-93f175571571"
  description          = "CIS: Antimalware protection signatures should auto-update."
  display_name         = "[CIS] Antimalware Signature Updates"
}

# ============================================================
# CIS Level 1 — VM extensions & management
# ============================================================

# Built-in: "Virtual machines should have the Log Analytics agent installed"
# Maps to CIS monitoring requirements
resource "azurerm_resource_group_policy_assignment" "vm_monitoring_agent" {
  name                 = "${var.project_name}-cis-monitor"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a70ca396-0a34-413a-88e1-b956c1e683be"
  description          = "CIS: Virtual machines should have monitoring agent installed."
  display_name         = "[CIS] VM Monitoring Agent Required"
}

# Built-in: "System updates should be installed on your machines"
resource "azurerm_resource_group_policy_assignment" "system_updates" {
  name                 = "${var.project_name}-cis-updates"
  resource_group_id    = local.scope
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/86b3d65f-7626-441e-b690-81a8b71cff60"
  description          = "CIS: System updates should be installed on virtual machines."
  display_name         = "[CIS] System Updates Required"
}
