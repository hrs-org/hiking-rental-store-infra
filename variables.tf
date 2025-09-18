variable "project" {
  description = "Short project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Southeast Asia"
}

variable "api_image" {
  description = "Docker image for .NET API"
  type        = string
}

variable "mysql_connection_string" {
  description = "MySQL connection string for EF Core"
  type        = string
  sensitive   = true
}

variable "mysql_admin_user" {
  description = "MySQL admin username"
  type        = string
  sensitive   = true
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}

variable "mysql_db_name" {
  description = "Database name"
  type        = string
  default     = "hrsdb"
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    managedBy   = "terraform"
    application = "hrs"
  }
}

variable "jwt_secret" {
  description = "Secret key used by the .NET API to sign and validate JWT tokens."
  type        = string
  sensitive   = true
}