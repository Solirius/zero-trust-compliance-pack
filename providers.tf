terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-hackday-tfstate"
    storage_account_name = "REPLACE_WITH_YOUR_OUTPUT_NAME" // replace var in prod, check init-environemnt for default ~~ Unique ID, use ./init-environment.sh to populate + execute initialisation correctly
    container_name       = "tfstate"
    key                  = "crawler-platform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}