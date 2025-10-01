terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-hrs-uat"
    storage_account_name = "sahrs1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
  tags     = var.common_tags
}
