output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "api_url" {
  value = azurerm_linux_web_app.api.default_hostname
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.db.fqdn
}

output "static_web_app_url" {
  value = azurerm_static_site.web.default_host_name
}
