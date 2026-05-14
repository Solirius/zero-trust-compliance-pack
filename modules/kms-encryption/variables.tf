variable "project_name" {
  description = "Project name"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,23}$", var.project_name))
    error_message = "Project name must be 3-24 lowercase alphanumeric chars or hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault to store the CMK"
  type        = string
}

variable "tags" {
  description = "Standard tags"
  type        = map(string)
  default     = {}
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the secure storage account"
  type        = list(string)
  default     = []
}
