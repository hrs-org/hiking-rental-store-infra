terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
  backend "azurerm" {
    resource_group_name = "rg-hrs-uat"
    storage_account_name = "sahrs1"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name = "rg-${var.project}-${var.environment}"
  location = var.location
  tags= var.common_tags
}

resource "azurerm_service_plan" "api_plan" {
  name = "asp-${var.project}-api-${var.environment}"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type = "Linux"
  sku_name = "B1"
  tags = var.common_tags
}

resource "azurerm_linux_web_app" "api" {
  name = "web-${var.project}-api-${var.environment}"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id = azurerm_service_plan.api_plan.id
  site_config {
    always_on = true
    ftps_state = "Disabled"
  }
  app_settings = {
    DOTNET_ENVIRONMENT = var.environment
    MYSQL_CONN = var.mysql_connection_string
    JWT_SECRET = var.jwt_secret
  }
  tags = var.common_tags
}

resource "azurerm_mysql_flexible_server" "db" {
  name = "mysql-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  administrator_login = var.mysql_admin_user
  administrator_password = var.mysql_admin_password
  sku_name = "B_Standard_B1ms"
  version = "8.0.21"

  backup_retention_days = 7
  geo_redundant_backup_enabled = false

  tags = var.common_tags
}

resource "azurerm_mysql_flexible_database" "db_main" {
  name = var.mysql_db_name
  resource_group_name = azurerm_resource_group.main.name
  server_name = azurerm_mysql_flexible_server.db.name
  charset = "utf8mb4"
  collation = "utf8mb4_unicode_ci"
}

resource "azurerm_static_site" "web" {
  name = "st-${var.project}-web-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location = "eastasia"
  sku_tier = "Free"
  sku_size = "Free"
  tags = var.common_tags
}