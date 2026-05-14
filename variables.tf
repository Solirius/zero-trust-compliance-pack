variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ztcp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "tags" {
  description = "Standard tags"
  type        = map(string)
  default = {
    Project = "Zero-Trust Compliance Pack"
    Owner   = "Owen"
  }
}
