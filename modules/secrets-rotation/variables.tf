variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Optional Log Analytics Workspace ID. If not provided, one will be created."
  type        = string
  default     = null
}

variable "key_vault_sku" {
  description = "Key Vault SKU name"
  type        = string
  default     = "premium"
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "SKU must be standard or premium."
  }
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted items"
  type        = number
  default     = 90
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days."
  }
}
