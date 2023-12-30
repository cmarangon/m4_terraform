
output "mysql_server_fqdn" {
  value = azurerm_mysql_server.mysql_server.fqdn
}

output "redis_host" {
  value = azurerm_redis_cache.redis_cache.hostname
}
