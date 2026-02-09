variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation"
  default = null
}
variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "rsg_name" {
  type        = string
  description = "The name of the Resource Group for this deployment"
}

variable "name" {
  description = "Specify the name of the App Service Plan"
  type        = string
}

variable "asp_id" {
  description = "The ID of the App Service Plan within which to create this App Service."
  type        = string
}

variable "enable_system_identity" {
  description = "Should the App enable System assigned Managed Identity"
  type        = bool
  default     = true
}

variable "connection_strings" {
  description = "One or more connection_string blocks"
  type = list(object({
    name   = string
    type   = string
    value  = string
    sticky = optional(bool, false)
  }))
  default = []
}

variable "mounted_storage_accounts" {
  description = "One or more mounted storage accounts"
  type = list(object({
    name         = string
    type         = string
    account_name = string
    share_name   = string
    access_key   = string
    mount_path   = string
  }))
  default = []
}

variable "site_configs" {
  description = "App Service Site Configs"
  type        = any
  default     = {}
}

variable "container_registry_use_managed_identity" {
  description = "Toggle to control the use of a managed identity to pull images from the container registry"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "One or more COR sources to allow"
  type        = list(string)
  default     = []
}

variable "cors_support_credentials" {
  description = "Support credentials with CORS sources"
  type        = bool
  default     = null
}

variable "create_pipeline" {
  description = "Including flag to make slots optional"
  type        = bool
  default     = false
}

variable "inherit_app_settings" {
  description = "Flag to determine if parent app settings should be inherited"
  type        = bool
  default     = false
}

variable "app_settings" {
  description = "A list of App Settings."
  type = list(object({
    name   = string
    value  = string
    sticky = optional(bool, false)
  }))
  default = null
}

variable "unique_slot_settings" {
  description = "Slot settings that are unique to the parent app Settings"
  type = list(object({
    name   = string
    value  = string
    sticky = optional(bool, false)
  }))
  default = []
}

variable "path_mappings" {
  description = "One or more virtual applications or directories"
  type = list(object({
    virtual_path        = string
    physical_path       = string
    preload             = bool
    virtual_directories = list(string)
  }))
  default = null
}

variable "custom_domain" {
  type = string
  description = "Custom Domain for App Service"
  default = null
}

variable "virtual_network_subnet_id" {
  description = "The Virtual Network Subnet ID used for vNET integration."
  type        = string
  default     = null
}

# variable "app_insights" {
#   type = object({
#     enabled           = bool
#     retention_in_days = number
#     sampling          = number
#     app_type          = string
#   })
# }
variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  type        = string
  default     = null
}

variable "ip_restrictions" {
  type = list(object({
    ip_restriction_name = string
    default_action      = string
    public_ip           = string
    priority            = number
  }))
  description = "App Service IP restrictions."
  default     = []
}

variable "client_affinity_enabled" {
  description = "Should Client Affinity be enabled?"
  type        = bool
  default     = false
}

variable "private_endpoints" {
  type = list(object({
    sub_resource_name = string
    #private_endpoint_subnet_id = string
    dns_zone_group      = string
    private_dns_zone_id = string
  }))
  description = "MSSQL private endpoint configuration"
  default     = []
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
  default     = null
}

variable "client_certificate_enabled" {
  type        = bool
  description = "Should Client Certificates be enabled?"
  default     = false
}

variable "client_certificate_mode" {
  type        = string
  description = "The Client Certificate mode. Possible values are Required, Optional, and OptionalInteractiveUser. This property has no effect when client_certificate_enabled is false."
  default     = "Optional"
}

variable "enable_auth_settings" {
  type = bool
  description = "Should AuthV2 settings be enabled?"
  default = false
}

# variable "default_provider" {
#   type = string
#   description = "The Default Authentication Provider to use when the unauthenticated_action is set to RedirectToLoginPage. Possible values include: apple, azureactivedirectory, facebook, github, google, twitter and the name of your custom_oidc_v2 provider."
#   default = null
# }

# variable "unauthenticated_action" {
#   type = string
#   description = "he action to take for requests made without authentication. Possible values include RedirectToLoginPage, AllowAnonymous, Return401, and Return403."
#   default = null
# }

# variable "runtime_version" {
#   type = string
#   description = "The Runtime Version of the Authentication and Authorisation feature of this App."
#   default = null
# }

# variable "require_authentication" {
#   type = bool
#   description = "Should the authentication flow be used for all requests.?"
#   default = false
# }

variable "client_secret_setting_name" {
  type = string
  description = "The App Setting name that contains the client secret of the Client."
  default = null
}

variable "app_registration_client_id" {
  type = string
  description = "he ID of the Client to use to authenticate with Azure Active Directory."
  default = null
}

variable "tenant_auth_endpoint" {
  type = string
  description = " The Azure Tenant Endpoint for the Authenticating Tenant."
  default = null
}

variable "allowed_applications" {
  type = list(string)
  description = "The list of allowed Applications for the Default Authorisation Policy."
  default = []
}

variable "allowed_audiences" {
  type = list(string)
  description = "Specifies a list of Allowed audience values to consider when validating JWTs issued by Azure Active Directory."
  default = []
}

variable "auth_settings_excluded_paths" {
  type = list(string)
  description = "The paths which should be excluded from the unauthenticated_action when it is set to RedirectToLoginPage"
  default = null
}

variable "public_certificate" {
  type = object({
    certificate_name = string
    certificate_pfx_base64_blob = optional(string, "")
    certificate_pfx_password = optional(string, "")
    key_vault_id = optional(string, "")
    key_vault_secret_id = optional(string, "")
  })

  description = "Object used to configure public certificates, i.e. not Azure managed, for the app services"
  default = null 
}

variable "enable_certificate_binding" {
  type = bool
  description = "Toggle used to enable public certificate binding"
  default = false
}
