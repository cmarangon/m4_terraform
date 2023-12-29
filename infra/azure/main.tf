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

# resource "azurerm_container_registry" "container_registry" {
#   name                = "m4terraformazurecontainerregistry"
#   resource_group_name = azurerm_resource_group.resource_group.name
#   location            = azurerm_resource_group.resource_group.location
#   sku                 = "Basic"
#   admin_enabled       = false
# }
# resource "azurerm_storage_account" "storage_account" {
#   name                     = "m4terraformstorageacc"
#   resource_group_name      = azurerm_resource_group.resource_group.name
#   location                 = azurerm_resource_group.resource_group.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_share" "storage_share_1" {
#   name                 = "m4terraformstorageshare1"
#   storage_account_name = azurerm_storage_account.storage_account.name
#   quota                = 1
# }

# resource "azurerm_storage_share" "storage_share_2" {
#   name                 = "m4terraformstorageshare2"
#   storage_account_name = azurerm_storage_account.storage_account.name
#   quota                = 1
# }

# resource "azurerm_storage_share" "storage_share_3" {
#   name                 = "m4terraformstorageshare3"
#   storage_account_name = azurerm_storage_account.storage_account.name
#   quota                = 1
# }

# resource "azurerm_storage_share" "storage_share_4" {
#   name                 = "m4terraformstorageshare4"
#   storage_account_name = azurerm_storage_account.storage_account.name
#   quota                = 1
# }

resource "azurerm_container_group" "container_group" {
  name                = "m4terraform-demo"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  exposed_port = [
    {
      port: var.app_port
      protocol = "TCP"
    },
    {
      port: var.api_port
      protocol = "TCP"
    }
  ]

  container {
    name   = "app"
    image  = "cmarangon/m4_terraform_app:latest"
    cpu    = "0.25"
    memory = "0.5"

    environment_variables = {
      NODE_ENV = "production"
    }

    ports {
      port     = var.app_port
      protocol = "TCP"
    }
  }

  container {
    name   = "api"
    image  = "cmarangon/m4_terraform_api:latest"
    cpu    = "0.25"
    memory = "0.5"

    ports {
      port     = var.api_port
      protocol = "TCP"
    }

    environment_variables = {
      DB_HOST = var.db_host
      DB_PORT = var.db_port
      DB_USER = var.db_user
      DB_PASSWORD = "${var.db_password}"
      DB_DATABASE = var.db_database
      REDIS_PASSWORD = var.redis_password
      REDIS_HOST = var.redis_host
      REDIS_PORT = var.redis_port
      DATABASE_URL = var.database_url
    }
  }

  container {
    name   = "redis"
    image  = "redis:alpine"
    cpu    = "0.25"
    memory = "0.5"

    ports {
      port     = var.redis_port
      protocol = "TCP"
    }
  }

  container {
    name   = "db"
    image  = "cmarangon/m4_terraform_db:latest"
    cpu    = "0.25"
    memory = "0.5"

    ports {
      port     = var.db_port
      protocol = "TCP"
    }

    environment_variables = {
      MYSQL_ROOT_PASSWORD = var.db_root_password
      MYSQL_ROOT_HOST = "%"
      MYSQL_USER = var.db_user
      MYSQL_PASSWORD = var.db_password
      MYSQL_DATABASE = var.db_database
    }
  }
}

output "ip_address" {
  value = azurerm_container_group.container_group.ip_address
}
