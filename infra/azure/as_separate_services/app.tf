resource "azurerm_container_app" "m4terraformapp" {
  name                         = "m4terraformapp"
  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  resource_group_name          = azurerm_resource_group.resource_group.name
  revision_mode                = "Single"

  ingress {
    target_port = 80
    exposed_port = 3000
    traffic_weight {
      percentage = 100
    }
  }

  template {
    container {
      name   = "app"
      image  = "cmarangon/m4_terraform_app:latest"
      cpu    = "0.25"
      memory = "0.5Gi"
    }
  }
}
