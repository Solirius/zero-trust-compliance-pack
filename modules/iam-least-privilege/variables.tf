variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "workload_principal_ids" {
  type    = list(string)
  default = []
}

variable "reader_principal_ids" {
  type    = list(string)
  default = []
}
