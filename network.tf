resource "azurerm_virtual_network" "main" {
  name = "vnet-${var.project}-${var.environment}"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = var.common_tags
}

resource "azurerm_subnet" "dmz" {
  name = "subnet-dmz"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "internal_app" {
  name = "subnet-internal-app"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.2.0/24"]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "firewall" {
  name = "AzureFirewallSubnet"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "internal_db" {
  name = "subnet-internal-db"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.4.0/24"]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_route_table" "dmz" {
  name = "rt-dmz"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name = "route-to-firewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_route_table" "internal" {
  name = "rt-internal"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name = "route-to-firewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "dmz" {
  subnet_id = azurerm_subnet.dmz.id
  route_table_id = azurerm_route_table.dmz.id
}

resource "azurerm_subnet_route_table_association" "internal_app" {
  subnet_id = azurerm_subnet.internal_app.id
  route_table_id = azurerm_route_table.internal.id
}

resource "azurerm_subnet_route_table_association" "internal_db" {
  subnet_id = azurerm_subnet.internal_db.id
  route_table_id = azurerm_route_table.internal.id
}

resource "azurerm_network_security_group" "dmz" {
  name = "nsg-dmz"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name = "AllowOutboundStorage"
    priority = 100
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "Storage"
  }
  security_rule {
    name = "AllowOutboundKeyVault"
    priority = 110
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "AzureKeyVault"
  }
  security_rule {
    name = "AllowOutboundAzureSQL"
    priority = 120
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "1433"
    source_address_prefix = "*"
    destination_address_prefix = "Sql"
  }
  security_rule {
    name = "AllowOutboundMonitoring"
    priority = 130
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "AzureMonitor"
  }
  security_rule {
    name = "AllowOutboundAPIMManagement"
    priority = 140
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "dmz" {
  subnet_id = azurerm_subnet.dmz.id
  network_security_group_id = azurerm_network_security_group.dmz.id
}