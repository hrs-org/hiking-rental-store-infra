variable "project" {
  description = "Short project name"
  type = string
}

variable "environment" {
  description = "Environment name (uat, prod)"
  type = string
}

variable "location" {
  description = "Azure region"
  type = string
  default = "Southeast Asia"
}

variable "api_image" {
  description = "Docker image for .NET API"
  type = string
}

variable "mysql_connection_string" {
  description = "MySQL connection string for EF Core"
  type = string
  sensitive = true
}

variable "mysql_admin_user" {
  description = "MySQL admin username"
  type = string
  sensitive = true
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  type = string
  sensitive = true
}

variable "mysql_db_name" {
  description = "Database name"
  type = string
  default = "hrsdb"
}

variable "common_tags" {
  description = "Common resource tags"
  type = map(string)
  default = {
    managedBy = "terraform"
    application = "hrs"
  }
}

variable "jwt_secret" {
  description = "Secret key used by the .NET API to sign and validate JWT tokens."
  type = string
  sensitive = true
}

variable "jwt_audience" {
  description = "JWT audience claim"
  type = string
  sensitive = true
}

variable "jwt_issuer" {
  description = "JWT issuer claim"
  type = string
  sensitive = true
}

variable "allowed_origins" {
  description = "Comma-separated list of allowed origins for CORS"
  type = string
  sensitive = true
}

variable "application_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  type = string
  sensitive = true
}

variable "application_insights_profilerfeature_version" {
  description = "Application Insights Profiler Feature Version"
  type = string
  default = "1.0.0"
}

variable "application_insights_snapshotfeature_version" {
  description = "Application Insights Snapshot Feature Version"
  type = string
  default = "1.0.0"
}

variable "application_insights_configuration_content" {
  description = "Application Insights Configuration Content"
  type = string
  default = ""
}

variable "application_insights_connection_string" {
  description = "Application Insights Connection String"
  type = string
  sensitive = true
}

variable "application_insights_agent_extension_version" {
  description = "Application Insights Agent Extension Version"
  type = string
  default = "~3"
}

variable "diagnostic_services_extension_version" {
  description = "Diagnostic Services Extension Version"
  type = string
  default = "~3"
}

variable "instrumentation_engine_extension_version" {
  description = "Instrumentation Engine Extension Version"
  type = string
  default = "disabled"
}

variable "snapshot_debugger_extension_version" {
  description = "Snapshot Debugger Extension Version"
  type = string
  default = "disabled"
}

variable "xdt_microsoft_application_insights_base_extensions" {
  description = "XDT Microsoft Application Insights Base Extensions"
  type = string
  default = "disabled"
}

variable "xdt_microsoft_application_insights_mode" {
  description = "XDT Microsoft Application Insights Mode"
  type = string
  default = "recommended"
}

variable "xdt_microsoft_application_insights_preempt_sdk" {
  description = "XDT Microsoft Application Insights Preempt SDK"
  type = string
  default = "disabled"
}

variable "app_setting_names" {
  description = "List of app setting names to be marked as sticky"
  type = list(string)
  default = []
}

variable "connection_string_names" {
  description = "List of connection string names to be marked as sticky"
  type = list(string)
  default = []
}

variable "publisher_name"{
  description = "API Management publisher name"
  type = string
  default = "HRS"
}

variable "publisher_email"{
  description = "API Management publisher email"
  type = string
}