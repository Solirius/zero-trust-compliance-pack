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

variable "enable_guest_configuration" {
  type        = bool
  description = "Enable Azure Policy guest configuration assignments for VM OS hardening."
  default     = true
}
