# Use Azure Resource Manager API
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Add resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-terraform-demo-2"
  location = "West Europe"
}
