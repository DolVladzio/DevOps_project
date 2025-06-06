variable "resource_group_name" {
  description = "Name of the resource group (overridden by config.json)"
  type        = string
  default     = "TerraformResourceGroup"
}

variable "location" {
  description = "Azure region where resources will be created (overridden by config.json)"
  type        = string
  default     = "Central US"
}

variable "db_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "postgres"
}

variable "allowed_ips" {
  description = "List of allowed IP addresses/CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Customize with your IP ranges
}

variable "use_key_vault_for_auth" {
  description = "Whether to use Key Vault for Azure provider authentication"
  type        = bool
  default     = false
}

variable "use_key_vault_for_db_credentials" {
  description = "Whether to use Key Vault for database credentials"
  type        = bool
  default     = true
}
