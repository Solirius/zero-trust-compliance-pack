variable "project_name" {
  type        = string
  description = "Project identifier. Used in resource naming."

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
  description = "Azure Resource Group to scope roles to."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

variable "workload_principal_ids" {
  type        = list(string)
  description = "Service principal object IDs to assign the workload operator role."
  default     = []

  validation {
    condition     = alltrue([for id in var.workload_principal_ids : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", id))])
    error_message = "All principal IDs must be valid UUIDs."
  }
}

variable "reader_principal_ids" {
  type        = list(string)
  description = "Principal object IDs for read-only audit access."
  default     = []

  validation {
    condition     = alltrue([for id in var.reader_principal_ids : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", id))])
    error_message = "All principal IDs must be valid UUIDs."
  }
}
