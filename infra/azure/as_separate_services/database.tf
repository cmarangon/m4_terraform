resource "azurerm_mysql_server" "mysql_server" {
  name                = "m4terraformmysqlserver"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "8.0"

  ssl_enforcement_enabled = true
  auto_grow_enabled       = false

  #   lifecycle {
  #     prevent_destroy = true
  #   }
}

resource "azurerm_mysql_database" "mysql_database" {
  name                = "todo_db"
  resource_group_name = azurerm_resource_group.resource_group.name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  #   lifecycle {
  #     prevent_destroy = true
  #   }
}
