variable "agw_name" {
  type        = string
  description = "The name of the Application Gateway Resource. Changing this forces a new resource to be created"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation"
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}

variable "rsg_name" {
  type        = string
  description = "The name of the Resource Group for this deployment"
}


variable "enable_autoscaling" {
  description = "Toggle to enable autoscaling"
  type        = bool
  default     = false
}

variable "key_vault_id" {
  description = "Specifies the id of the Key Vault resource"
  type        = string
}

variable "key_vault_tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "key_vault_auth_use_access_policy" {
  type        = bool
  description = "Toggle to use access policy or RBAC for the keyvault access to the user assigned identity"
}

variable "agw_sku" {
  description = "The SKU/Tier to use for the Application Gateway. Supported Values are Standard_v2 or WAF_v2"
  type        = string
}

variable "gateway_subnet_id" {
  description = "The ID of the Subnet delegated to App Gateway"
  type        = string
}

variable "enable_private_frontend" {
  type        = bool
  description = "Toggle used to switch the Application Gateway to Private IP Only mode"
  default     = false
}

variable "private_ip_address" {
  type        = string
  description = "The private IP address to assign to the application gateway"
  default     = null
}

variable "http_listeners_path_based" {
  type = list(object({
    domain           = string
    public_hostnames = list(string)
    certificate_name = string
    path_rules = list(object({
      name                             = string
      backend_paths                    = list(string)
      backend_path_override            = optional(string, "")
      health_check_path                = string
      backend_fqdns                    = list(string)
      backend_request_timeout          = number
      backend_health_probe_status_code = optional(list(string), ["200-399"])
      rewrite_rule_set_name            = optional(string, "")
      trusted_root_certificate_names = optional(list(string), [])
    }))
    default_backend_address_pool_fqdns       = list(string)
    default_backend_path_override            = optional(string, "")
    default_backend_health_check_path        = string
    default_backend_health_probe_status_code = optional(list(string), ["200-399"])
    default_rewrite_rule_set_name            = optional(string)
    default_trusted_root_certificate_names = optional(list(string), [])

  }))
  description = "List of object used to configure http listeners and their path mapping rules"
  default     = []
}

variable "http_listeners_domain_based" {
  type = list(object({
    domain                           = string
    public_hostnames                 = list(string)
    backend_port                     = number
    certificate_name                 = string
    backend_pool_name                = string
    backend_path_override            = optional(string, "")
    backend_health_check_path        = string
    backend_health_probe_status_code = optional(list(string), ["200-399"])
    backend_probe_hostname           = optional(string)
    pick_host_name_from_backend_pool = bool
    rewrite_rule_set_name            = optional(string)
    trusted_root_certificate_names = optional(list(string), [])
  }))
  description = "List of object used to configure http listeners and their path mapping rules"
  default     = []
}

variable "domain_based_backend_pools" {
  type = list(object({
    backend_pool_name = string
    ip_addresses      = optional(list(string))
    fqdns             = optional(list(string))
  }))
  description = "List of objects used to configure backend pools"
  default     = []
}

variable "trusted_root_certificates" {
  type = list(object({
    name = string
    key_vault_secret_id = optional(string)
    trusted_root_cert_file = optional(string)
  }))
  description = "List of objects used to configure trusted root certificates"
  default = []
}

variable "ssl_certificates" {
  type = list(object({
    certificate_name       = string
    key_vault_secret_id    = optional(string)
    pfx_cert_file          = optional(string)
    pfx_cert_file_password = optional(string)
  }))
  description = "List of certificates which needs to be uploaded in 443 listners"
}


variable "domain_name_label" {
  description = "an A DNS record is created for the public IP in the Microsoft Azure DNS system"
  type        = string
  default     = null
}

variable "zones" {
  description = "A collection containing the availability zone to allocate the resources being deployed"
  type        = list(string)
  default     = null
}

variable "default_gateway_instance_count" {
  description = "An override for the Application Gateway instance count when auto scaling is not in use"
  type        = number
  default     = 2
}

variable "maximum_gateway_instance_count" {
  description = "specifying max number of Application Gateway instances when autoscaling is in use. Maximum number is 125"
  type        = number
  default     = 125
}

variable "enable_gateway_diagnostic_logs" {
  type        = bool
  description = "Toggle to enable or disable collection of the application gateway diagnostics logs"
  default     = false
}

variable "rewrite_rule_sets" {
  type = list(object({
    ruleset_name = string
    rewrite_rules = list(object({
      name          = string
      rule_sequence = number
      condition = optional(list(object({
        variable    = string
        pattern     = string
        ignore_case = bool
        negate      = bool
      })), [])
      request_header_configuration = optional(list(object({
        header_name  = string
        header_value = string
      })), [])
      response_header_configuration = optional(list(object({
        header_name  = string
        header_value = string
      })), [])
    }))
  }))
  description = "List of objects used to configure rewrite rule sets"
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace where diagnostics logs are collected"
  default     = null
}

variable "waf_mode" {
  description = "The Web Application Firewall Mode. Possible values are Detection and Prevention."
  type        = string
  default     = "Detection"
}

variable "waf_file_upload_enforcement" {
  type        = bool
  description = "Toggle to enforce Whether the firewall should block a request with upload size greater then file_upload_limit_in_mb"
  default     = true
}

variable "waf_request_body_check" {
  type        = bool
  description = "Is Request Body Inspection enabled?"
  default     = true
}

variable "waf_max_request_body_size_in_kb" {
  type        = number
  description = " The Maximum Request Body Size in KB. Accepted values are in the range 8 to 2000"
  default     = 128
}

variable "enable_log_scrubbing" {
  type        = bool
  description = "Master Toggle to enable the log scrubbing feature on the WAF policy"
  default     = false
}

variable "log_scrubbing_rules" {
  type = list(object({
    enable                  = bool
    match_variable          = string
    selector_match_operator = string
    selector                = string
  }))
  description = "List of objects used to configure log scrubbing rules"
  default     = []
}

variable "waf_custom_rules" {
  type = list(object({
    name      = string
    action    = string
    enable    = optional(bool, true)
    priority  = number
    rule_type = string
    match_conditions = list(object({
      match_variables = list(object({
        variable_name = string
        selector      = optional(string)
      }))
      match_values       = optional(list(string))
      operator           = string
      negative_condition = optional(string)
      transforms         = optional(list(string))
    }))
    rate_limit_duration  = optional(string)
    rate_limit_threshold = optional(string)
    group_rate_limit_by  = optional(string)
  }))
  description = "List of objects used to configure the WAF custom rules"
  default     = []
}

variable "waf_managed_rule_sets" {
  type = list(object({
    type    = string
    version = string
    rule_group_override = optional(list(object({
      rule_group_name = string
      rule = list(object({
        id      = string
        enabled = optional(bool, false)
        action  = string
      }))
    })))
  }))
  description = "List of objects used to configure the WAF custom rules"
  default = [
    {
      type    = "OWASP"
      version = "3.2"
    }
  ]
}

variable "waf_managed_rule_exclusions" {
  type = list(object({
    match_variable          = string
    selector                = string
    selector_match_operator = string
    excluded_rule_set = list(object({
      type    = string
      version = string
      rule_group = list(object({
        rule_group_name = string
        excluded_rules  = optional(string)
      }))
    }))
  }))
  description = "List of objects used to configure WAF managed rule exclusions"
  default     = []
}

variable "control_agw_identity_outside_of_module" {
  type        = bool
  default     = false
  description = "This variable is being used in situations where RBAC or Access Policies cannot be performed by the identity that creates the gateway resources. If set to true, Access to the Keyvault that holds the gateway certificates must be done by other means"
}

variable "ssl_policy_name" {
  type        = string
  description = "he Name of the Policy e.g. AppGwSslPolicy20170401S. Required if policy_type is set to Predefined"
  default     = "AppGwSslPolicy20220101S"
}
