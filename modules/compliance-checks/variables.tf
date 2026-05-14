variable "project_name" {
  type        = string
  description = "Project identifier."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,23}$", var.project_name))
    error_message = "Project name must be 3-24 lowercase alphanumeric chars or hyphens, starting with a letter."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group to scope policies to."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault resource ID to monitor. Null if secrets module disabled."
  default     = null
}

variable "key_vault_enabled" {
  type        = bool
  description = "Whether Key Vault is enabled. Used for conditional alerting."
  default     = true
}

variable "enable_activity_log_alerts" {
  type        = bool
  description = "Enable activity log alerts for security events."
  default     = true
}
