variable "project_name" {
  type        = string
  description = "Project name used across all modules for resource naming."
  default     = "ztcp"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,23}$", var.project_name))
    error_message = "Project name must be 3-24 lowercase alphanumeric chars or hyphens, starting with a letter."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment for all modules."
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "West Europe"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources across all modules."
  default = {
    Project = "Zero-Trust Compliance Pack"
  }
}

# --- Module toggles ---

variable "enable_secrets_rotation" {
  type        = bool
  description = "Enable the secrets rotation module."
  default     = true
}

variable "enable_iam_least_privilege" {
  type        = bool
  description = "Enable the IAM least-privilege module."
  default     = true
}

variable "enable_kms_encryption" {
  type        = bool
  description = "Enable the KMS encryption module."
  default     = true
}

variable "enable_compliance_checks" {
  type        = bool
  description = "Enable the compliance checks module."
  default     = true
}

variable "enable_vm_compliance" {
  type        = bool
  description = "Enable the VM compliance (CIS Level 1 benchmark) module."
  default     = true
}

# --- Secrets rotation config ---

variable "allowed_ips" {
  type        = list(string)
  description = "IP CIDR ranges allowed to access Key Vault."
  default     = []
}

# --- IAM config ---

variable "workload_principal_ids" {
  type        = list(string)
  description = "Service principal object IDs for workload operator role."
  default     = []
}

variable "reader_principal_ids" {
  type        = list(string)
  description = "Principal object IDs for security reader role."
  default     = []
}
