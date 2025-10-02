terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-hrs-uat"
    storage_account_name = "sahrs1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_service_plan" "api_plan" {
  name                = "asp-${var.project}-api-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.common_tags
}

resource "azurerm_linux_web_app" "api" {
  name                = "web-${var.project}-api-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.api_plan.id
  site_config {
    always_on  = true
    ftps_state = "Disabled"
  }
  app_settings = {
    DOTNET_ENVIRONMENT                              = var.environment
    AllowedOrigins                                  = var.allowed_origins
    ConnectionStrings__DefaultConnection            = var.mysql_connection_string
    Jwt__Key                                        = var.jwt_secret
    Jwt__Audience                                   = var.jwt_audience
    Jwt__Issuer                                     = var.jwt_issuer
    APPINSIGHTS_INSTRUMENTATIONKEY                  = var.application_insights_instrumentation_key
    APPINSIGHTS_PROFILERFEATURE_VERSION             = var.application_insights_profilerfeature_version
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = var.application_insights_snapshotfeature_version
    APPLICATIONINSIGHTS_CONFIGURATION_CONTENT       = var.application_insights_configuration_content
    APPLICATIONINSIGHTS_CONNECTION_STRING           = var.application_insights_connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION      = var.application_insights_agent_extension_version
    DiagnosticServices_EXTENSION_VERSION            = var.diagnostic_services_extension_version
    InstrumentationEngine_EXTENSION_VERSION         = var.instrumentation_engine_extension_version
    SnapshotDebugger_EXTENSION_VERSION              = var.snapshot_debugger_extension_version
    XDT_MicrosoftApplicationInsights_BaseExtensions = var.xdt_microsoft_application_insights_base_extensions
    XDT_MicrosoftApplicationInsights_Mode           = var.xdt_microsoft_application_insights_mode
    XDT_MicrosoftApplicationInsights_PreemptSdk     = var.xdt_microsoft_application_insights_preempt_sdk
  }

  sticky_settings {
    app_setting_names       = var.app_setting_names
    connection_string_names = var.connection_string_names
  }
  tags = var.common_tags
}

resource "azurerm_mysql_flexible_server" "db" {
  name                   = "mysql-${var.project}-${var.environment}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  zone                   = "2"
  administrator_login    = var.mysql_admin_user
  administrator_password = var.mysql_admin_password
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  tags = var.common_tags
}

resource "azurerm_mysql_flexible_database" "db_main" {
  name                = var.mysql_db_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.db.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_0900_ai_ci"
}

resource "azurerm_static_site" "web" {
  name                = "st-${var.project}-web-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "eastasia"
  sku_tier            = "Free"
  sku_size            = "Free"
  tags                = var.common_tags
}

resource "azurerm_sendgrid_account" "main" {
  name                = "sendgrid-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_name            = "free"
  tags                = var.common_tags
}
