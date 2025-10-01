output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "api_url" {
  value = azurerm_api_management.gateway.gateway_url
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.db.fqdn
}

output "static_web_app_url" {
  value = azurerm_static_web_app.web.default_host_name
}
