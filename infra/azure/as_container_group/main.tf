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
  name     = "rg-terraform-demo"
  location = "West Europe"
}

# Add storage for db persistency
resource "azurerm_storage_account" "storage_account" {
  name                     = "m4terraformstorageacc"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "azurerm_storage_share" "storage_share" {
  name                 = "m4terraformstoragesharedb"
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = 1

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Add container group to put all containers
resource "azurerm_container_group" "container_group" {
  name                = "m4terraform-demo"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  ip_address_type     = "Public"
  os_type             = "Linux"

  exposed_port = [
    {
      port : var.app_port
      protocol = "TCP"
    },
    {
      port : var.api_port
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
      DB_HOST        = var.db_host
      DB_PORT        = var.db_port
      DB_USER        = var.db_user
      DB_PASSWORD    = "${var.db_password}"
      DB_DATABASE    = var.db_database
      REDIS_PASSWORD = var.redis_password
      REDIS_HOST     = var.redis_host
      REDIS_PORT     = var.redis_port
      DATABASE_URL   = var.database_url
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

    volume {
      name       = "mysql-data-volume"
      mount_path = "/var/lib/mysql"

      storage_account_name = azurerm_storage_account.storage_account.name
      storage_account_key  = azurerm_storage_account.storage_account.primary_access_key
      share_name           = azurerm_storage_share.storage_share.name
    }

    environment_variables = {
      MYSQL_ROOT_PASSWORD = var.db_root_password
      MYSQL_ROOT_HOST     = "%"
      MYSQL_USER          = var.db_user
      MYSQL_PASSWORD      = var.db_password
      MYSQL_DATABASE      = var.db_database
    }
  }
}
