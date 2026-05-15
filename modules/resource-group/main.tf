locals {
  module_tags = merge(var.tags, {
    managed_by  = "terraform"
    module_name = "resource-group"
    environment = var.environment
  })
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = local.module_tags
}
