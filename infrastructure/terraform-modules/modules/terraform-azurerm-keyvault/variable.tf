variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource"
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "rsg_name" {
  type        = string
  description = "The name of the Resource Group for this deployment"
}

# Define Resource Group for this deployment
variable "name" {
  description = "Specify the name of the Key Vault."
  type        = string
}

# Variables for Key Vault
variable "enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = false
}
variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}
variable "enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}
variable "enable_rbac_authorization" {
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  type        = bool
  default     = false
}
variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = string
}
variable "azurerm_tenant_id" {
  type        = string
  description = "The Tenant ID where this Keyvault should reside"
}
variable "purge_protection_enabled" {
  description = "Purge Protection for this Key Vault"
  type        = string
  default     = false
}
variable "keyvault_sku" {
  description = "The Name of the SKU used for this Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for this Key Vault."
  default     = false
}

variable "enable_network_acls" {
  type        = bool
  description = "Toggle Flag to enable/disable network access lists"
  default     = false
}
variable "traffic_bypass" {
  type        = string
  description = "Specifies which traffic can bypass the network rules. Possible values are AzureServices and None"
  default     = "None"
}

variable "default_action" {
  type        = string
  description = "The Default Action to use when no rules match"
  default     = "Deny"
}

variable "public_ips" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed."
  default     = []
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "One or more Subnet IDs which should be able to access this Key Vault."
  default     = []
}

variable "private_endpoints" {
  type = list(object({
    sub_resource_name   = string
    dns_zone_group      = string
    private_dns_zone_id = string
  }))
  description = "Keyvault private endpoint configuration"
  default     = []
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace where diagnostics logs are collected"
  default     = null
}

variable "enable_keyvault_diagnostic_logs" {
  type        = bool
  description = "Toggle to enable or disable collection of the application gateway diagnostics logs"
  default     = false
}
