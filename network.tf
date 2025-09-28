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
}

resource "azurerm_subnet" "internal" {
  name = "subnet-internal"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "firewall" {
  name = "AzureFirewallSubnet"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = ["10.0.3.0/24"]
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

resource "azurerm_subnet_route_table_association" "internal" {
  subnet_id = azurerm_subnet.internal.id
  route_table_id = azurerm_route_table.internal.id
}