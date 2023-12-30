resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "m4terraformloganalytics"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "Free"
}

resource "azurerm_container_app_environment" "container_app_environment" {
  name                       = "m4terraformcontappenv"
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
