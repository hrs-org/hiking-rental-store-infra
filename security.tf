 resource "azurerm_firewall" "main" {
  name = "fw-${var.project}-${var.environment}"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name = "fw-ipconfig"
    subnet_id = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_public_ip" "firewall" {
  name = "fw-pip"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_firewall_network_rule_collection" "allow_apim_to_api" {
  name = "AllowAPIMtoAPI"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority = 100
  action = "Allow"

  rule {
    name = "AllowHTTPSFromDMZToInternal"
    protocols = ["TCP"]
    source_addresses = [azurerm_subnet.dmz.address_prefixes[0]]
    destination_addresses = [
      azurerm_subnet.internal_app.address_prefixes[0],
      azurerm_subnet.internal_db.address_prefixes[0]
    ]
    destination_ports = ["443"]
  }
}

resource "azurerm_firewall_network_rule_collection" "allow_internal_to_azure" {
  name = "AllowInternalToAzure"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority = 200
  action = "Allow"

  rule {
    name = "AllowHTTPSOutbound"
    protocols = ["TCP"]
    source_addresses = [
      azurerm_subnet.internal_app.address_prefixes[0],
      azurerm_subnet.internal_db.address_prefixes[0]
    ]
    destination_addresses = ["*"]
    destination_ports = ["443"]
  }
}

resource "azurerm_firewall_network_rule_collection" "allow_apim_to_azure_sql" {
  name = "AllowAPIMtoAzureSQL"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = azurerm_resource_group.main.name
  priority = 300
  action = "Allow"

  rule {
    name = "AllowSQLOutbound"
    protocols = ["TCP"]
    source_addresses = [azurerm_subnet.dmz.address_prefixes[0]]
    destination_addresses = ["*"]
    destination_ports = ["1433"]
  }
}

resource "azurerm_security_center_subscription_pricing" "app_service_defender" {
  tier = "Standard"
  resource_type = "AppServices"
}

resource "azurerm_security_center_subscription_pricing" "storage_defender" {
  tier = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "sql_defender" {
  tier = "Standard"
  resource_type = "SqlServers"
}