variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
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
