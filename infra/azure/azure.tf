# Use Azure Resource Manager API
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Add resource group
resource "azurerm_resource_group" "resource_group" {
  name = "rg-terraform-demo"
  location = "West Europe"
}

# Create a storage account
# resource "azurerm_storage_account" "storage_account" {
#   name = "terraformdemoazure1"
#   resource_group_name = azurerm_resource_group.resource_group.name
#   location = azurerm_resource_group.resource_group.location
#   account_tier = "Standard"
#   account_replication_type = "LRS"
# }

resource "azurerm_container_registry" "container_registry" {
  name                = "azurecontainerregistry"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_container_app_environment" "container_app_environment" {
  name                       = "Looking for a good name"
  location                   = azurerm_resource_group.resourece_group.location
  resource_group_name        = azurerm_resource_group.resourece_group.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.resourece_group.id
}

resource "azurerm_container_app" "container_app" {
  name                         = "terraform-demo-app"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = azurerm_resource_group.resource_group.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
