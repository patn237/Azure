resource "azurerm_public_ip" "agw_pip" {
  name                = join("-", ["pip", var.agw_name])
  location            = var.az_region
  resource_group_name = var.rsg_name
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = var.zones == null ? null : var.zones
  domain_name_label   = var.domain_name_label

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "agw_uaid" {
  resource_group_name = var.rsg_name
  location            = var.az_region
  name                = join("-", ["uaid", var.agw_name])

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "kv_policy" {
  count = var.key_vault_auth_use_access_policy == true && var.control_agw_identity_outside_of_module == false ? 1 : 0

  key_vault_id = var.key_vault_id
  tenant_id    = var.key_vault_tenant_id
  object_id    = azurerm_user_assigned_identity.agw_uaid.principal_id

  certificate_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get",
  ]

  depends_on = [azurerm_user_assigned_identity.agw_uaid]
}

resource "azurerm_role_assignment" "kv_rbac_secret" {
  count                = var.key_vault_auth_use_access_policy == false && var.control_agw_identity_outside_of_module == false ? 1 : 0
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.agw_uaid.principal_id

  depends_on = [azurerm_user_assigned_identity.agw_uaid]
}

resource "azurerm_role_assignment" "kv_rbac_certificate" {
  count                = var.key_vault_auth_use_access_policy == false && var.control_agw_identity_outside_of_module == false ? 1 : 0
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Certificate User"
  principal_id         = azurerm_user_assigned_identity.agw_uaid.principal_id

  depends_on = [azurerm_user_assigned_identity.agw_uaid]
}

locals {
  list_of_backend_pools_to_create = flatten([for values in var.http_listeners_path_based :
    flatten([for backend in values.path_rules :
      {
        backend_name                     = backend.name
        backend_paths                    = backend.backend_paths
        backend_fqdns                    = backend.backend_fqdns
        backend_path_override            = backend.backend_path_override
        backend_health_check_path        = backend.health_check_path
        backend_request_timeout          = backend.backend_request_timeout
        backend_public_domain            = values.domain
        backend_health_probe_status_code = backend.backend_health_probe_status_code
        rewrite_rule_set_name            = backend.rewrite_rule_set_name
        trusted_root_certificate_names = backend.trusted_root_certificate_names
      }
    ])
  ])

  /* Priorities (where p is priority, and n is index)
    Path Based 80, p = 4n - 3
    Path Based 443, p = 4n - 2
    Domain Based 80, p = 4n - 1
    Domain Based 443, p = 4n
  */

}


resource "azurerm_application_gateway" "appgw" {

  name                = var.agw_name
  resource_group_name = var.rsg_name
  location            = var.az_region

  enable_http2 = true

  zones = var.zones == null ? null : var.zones

  force_firewall_policy_association = var.agw_sku == "WAF_v2" ? true : null

  firewall_policy_id = var.agw_sku == "WAF_v2" ? azurerm_web_application_firewall_policy.waf[0].id : null

  ssl_policy {
    policy_type = "Predefined"
    policy_name = var.ssl_policy_name
  }

  dynamic "trusted_root_certificate" {
    for_each = { for cert in var.trusted_root_certificates : cert.name => cert }

    content {
      name = trusted_root_certificate.value.name
      key_vault_secret_id = try(trusted_root_certificate.value.key_vault_secret_id, null)
      data                = try(trusted_root_certificate.value.trusted_root_cert_file, null)    
    } 
     
  }

  # Default Path Based Backend Address Pools
  dynamic "backend_address_pool" {
    for_each = try({ for listener in var.http_listeners_path_based : listener.domain => listener }, {})
    content {
      name  = join("-", [backend_address_pool.value.domain, "default_be_pool"])
      fqdns = backend_address_pool.value.default_backend_address_pool_fqdns
    }
  }

  # Path Based Backend Address Pools
  dynamic "backend_address_pool" {
    for_each = try({ for index, pool in local.list_of_backend_pools_to_create : format("%03d", index) => pool }, {})
    content {
      name  = join("-", [backend_address_pool.value.backend_name, "be-pool"])
      fqdns = backend_address_pool.value.backend_fqdns
    }
  }

  # Basic Domain Based Backend Address Pools
  dynamic "backend_address_pool" {
    for_each = try({ for pool in var.domain_based_backend_pools : pool.backend_pool_name => pool }, {})
    content {
      name         = join("-", [backend_address_pool.value.backend_pool_name, "be-pool"])
      ip_addresses = try(backend_address_pool.value.ip_addresses, null)
      fqdns        = try(backend_address_pool.value.fqdns, null)
    }
  }

  # Basic Domain Based Health Probes
  dynamic "probe" {
    for_each = try({ for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }, {})
    content {

      name = join("_", ["probe", probe.value.backend_port, probe.value.domain])

      interval = "30"

      protocol = probe.value.backend_port == 443 ? "Https" : "Http"

      path = probe.value.backend_health_check_path

      timeout = "30"

      unhealthy_threshold = "3"

      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_pool == false ? false : true

      host = probe.value.pick_host_name_from_backend_pool == true ? null : probe.value.backend_probe_hostname

      match {
        status_code = probe.value.backend_health_probe_status_code
      }
    }
  }

  # Default Backend Probes on URL Path Map
  dynamic "probe" {
    for_each = try({ for listener in var.http_listeners_path_based : listener.domain => listener }, {})
    content {
      name                                      = join("_", [probe.value.domain, "default_probe_443"])
      interval                                  = "30"
      protocol                                  = "Https"
      path                                      = probe.value.default_backend_health_check_path
      timeout                                   = "30"
      unhealthy_threshold                       = "3"
      pick_host_name_from_backend_http_settings = true
      match {
        status_code = probe.value.default_backend_health_probe_status_code
        body        = ""
      }
    }
  }

  # Path based Probes on URL Path Map Paths
  dynamic "probe" {
    for_each = try({ for index, pool in local.list_of_backend_pools_to_create : format("%03d", index) => pool }, {})
    content {
      name                                      = join("_", [probe.value.backend_name, "probe_443"])
      interval                                  = "30"
      protocol                                  = "Https"
      path                                      = probe.value.backend_health_check_path
      timeout                                   = "30"
      unhealthy_threshold                       = "3"
      pick_host_name_from_backend_http_settings = true
      match {
        status_code = probe.value.backend_health_probe_status_code
        body        = ""
      }
    }
  }

  # Basic Domain Based Backend Http Settings
  dynamic "backend_http_settings" {
    for_each = try({ for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }, {})
    content {

      name = join("_", [backend_http_settings.value.domain, backend_http_settings.value.backend_port, "be_setting"])

      cookie_based_affinity = "Disabled"

      affinity_cookie_name = "ApplicationGatewayAffinity"

      port = backend_http_settings.value.backend_port

      probe_name = join("_", ["probe", backend_http_settings.value.backend_port, backend_http_settings.value.domain])

      protocol = backend_http_settings.value.backend_port == 443 ? "Https" : "Http"

      request_timeout = 30

      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_pool == true ? true : false

      host_name = backend_http_settings.value.pick_host_name_from_backend_pool == true ? null : backend_http_settings.value.backend_probe_hostname

      trusted_root_certificate_names = backend_http_settings.value.trusted_root_certificate_names == [] ? null : backend_http_settings.value.trusted_root_certificate_names
    }
  }

  # Path Based Default Backend Http Settings
  dynamic "backend_http_settings" {
    for_each = try({ for listener in var.http_listeners_path_based : listener.domain => listener }, {})

    content {

      name = join("_", [backend_http_settings.value.domain, "default_443_be_setting"])

      cookie_based_affinity = "Disabled"

      affinity_cookie_name = "ApplicationGatewayAffinity"

      port = "443"

      probe_name = join("_", [backend_http_settings.value.domain, "default_probe_443"])

      protocol = "Https"

      request_timeout = 30

      pick_host_name_from_backend_address = true

      path = backend_http_settings.value.default_backend_path_override == "" ? null : backend_http_settings.value.default_backend_path_override

      trusted_root_certificate_names = backend_http_settings.value.default_trusted_root_certificate_names == [] ? null : backend_http_settings.value.default_trusted_root_certificate_names  
    }
  }

  # Path Based Backend Http Settings for Paths
  dynamic "backend_http_settings" {
    for_each = try({ for index, pool in local.list_of_backend_pools_to_create : format("%03d", index) => pool }, {})

    content {

      cookie_based_affinity = "Disabled"

      name = join("_", [backend_http_settings.value.backend_name, "443_be_setting"])

      port = "443"

      probe_name = join("_", [backend_http_settings.value.backend_name, "probe_443"])

      protocol = "Https"

      request_timeout = backend_http_settings.value.backend_request_timeout

      pick_host_name_from_backend_address = true

      path = backend_http_settings.value.backend_path_override == "" ? null : backend_http_settings.value.backend_path_override

      trusted_root_certificate_names = backend_http_settings.value.trusted_root_certificate_names == [] ? null : backend_http_settings.value.trusted_root_certificate_names    
    }
  }

  frontend_ip_configuration {
    name                 = join("-", [var.agw_name, "feip-config"])
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  dynamic "frontend_ip_configuration" {
    for_each = (var.enable_private_frontend == true) ? [0] : []

    content {
      name                          = join("-", [var.agw_name, "feip-private-config"])
      subnet_id                     = var.gateway_subnet_id
      private_ip_address            = try(var.private_ip_address, null)
      private_ip_address_allocation = "Static"

    }

  }

  frontend_port {
    name = "front_end_80"
    port = "80"
  }

  frontend_port {
    name = "front_end_443"
    port = "443"
  }

  gateway_ip_configuration {
    name      = join("-", [var.agw_name, "gwip-config"])
    subnet_id = var.gateway_subnet_id
  }

  # Basic Domain Based Listener
  dynamic "http_listener" {
    for_each = try({ for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }, {})
    content {
      name = join("_", [http_listener.value.domain, "443"])

      frontend_ip_configuration_name = var.enable_private_frontend == true ? join("-", [var.agw_name, "feip-private-config"]) : join("-", [var.agw_name, "feip-config"])

      frontend_port_name = "front_end_443"

      host_names = http_listener.value.public_hostnames

      protocol = "Https"

      ssl_certificate_name = http_listener.value.certificate_name

      require_sni = true

      firewall_policy_id = var.agw_sku == "WAF_v2" ? azurerm_web_application_firewall_policy.waf[0].id : null
    }
  }

  # Basic Domain Based Listener
  dynamic "http_listener" {
    for_each = try({ for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }, {})
    content {
      name = join("_", [http_listener.value.domain, "80"])

      frontend_ip_configuration_name = var.enable_private_frontend == true ? join("-", [var.agw_name, "feip-private-config"]) : join("-", [var.agw_name, "feip-config"])

      frontend_port_name = "front_end_80"

      host_names = http_listener.value.public_hostnames

      protocol = "Http"

      firewall_policy_id = var.agw_sku == "WAF_v2" ? azurerm_web_application_firewall_policy.waf[0].id : null
    }
  }

  # Path Based Listener
  dynamic "http_listener" {
    for_each = try({ for listener in var.http_listeners_path_based : listener.domain => listener }, {})
    content {
      name = join("_", [http_listener.value.domain, "443"])

      frontend_ip_configuration_name = var.enable_private_frontend == true ? join("-", [var.agw_name, "feip-private-config"]) : join("-", [var.agw_name, "feip-config"])

      frontend_port_name = "front_end_443"

      host_names = http_listener.value.public_hostnames

      protocol = "Https"

      ssl_certificate_name = http_listener.value.certificate_name

      require_sni = true

      firewall_policy_id = var.agw_sku == "WAF_v2" ? azurerm_web_application_firewall_policy.waf[0].id : null
    }
  }

  # Path Based Listener
  dynamic "http_listener" {
    for_each = try({ for listener in var.http_listeners_path_based : listener.domain => listener }, {})
    content {
      name                           = join("_", [http_listener.value.domain, "80"])
      frontend_ip_configuration_name = var.enable_private_frontend == true ? join("-", [var.agw_name, "feip-private-config"]) : join("-", [var.agw_name, "feip-config"])
      frontend_port_name             = "front_end_80"
      host_names                     = http_listener.value.public_hostnames
      protocol                       = "Http"
      firewall_policy_id             = var.agw_sku == "WAF_v2" ? azurerm_web_application_firewall_policy.waf[0].id : null
    }
  }

  dynamic "ssl_certificate" {
    for_each = { for cert in var.ssl_certificates : cert.certificate_name => cert }

    content {
      name                = ssl_certificate.value.certificate_name
      key_vault_secret_id = try(ssl_certificate.value.key_vault_secret_id, null)
      data                = try(ssl_certificate.value.pfx_cert_file, null)
      password            = try(ssl_certificate.value.pfx_cert_file_password, null)
    }
  }

  identity {
    identity_ids = [azurerm_user_assigned_identity.agw_uaid.id]
    type         = "UserAssigned"
  }

  # Path Based Redirect Config 
  dynamic "redirect_configuration" {
    for_each = { for listener in var.http_listeners_path_based : listener.domain => listener }

    content {
      name                 = join("-", [redirect_configuration.value.domain, "redir-config"])
      redirect_type        = "Permanent"
      target_listener_name = join("_", [redirect_configuration.value.domain, "443"])
      include_path         = true
      include_query_string = true
    }
  }


  # Domain Based Redirect Config  
  dynamic "redirect_configuration" {
    for_each = { for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }
    content {
      name                 = join("-", [var.agw_name, redirect_configuration.value.domain, "redir-config"])
      redirect_type        = "Permanent"
      target_listener_name = join("_", [redirect_configuration.value.domain, "443"])
      include_path         = true
      include_query_string = true
    }
  }

  dynamic "url_path_map" {
    for_each = { for path_maps in var.http_listeners_path_based : path_maps.domain => path_maps }

    content {
      name = join("_", [url_path_map.value.domain, "url_path_map_80"])

      default_redirect_configuration_name = join("-", [url_path_map.value.domain, "redir-config"])

      dynamic "path_rule" {

        for_each = { for index, pool in local.list_of_backend_pools_to_create : format("%03d", index) => pool if url_path_map.value.domain == pool.backend_public_domain }

        content {
          name = join("_", [path_rule.value.backend_name, "path_rule_80"])

          paths = path_rule.value.backend_paths

          redirect_configuration_name = join("-", [url_path_map.value.domain, "redir-config"])
        }
      }
    }
  }

  dynamic "url_path_map" {
    for_each = { for listener in var.http_listeners_path_based : listener.domain => listener }

    content {
      name = join("_", [url_path_map.value.domain, "url_path_map_443"])

      default_backend_http_settings_name = join("_", [url_path_map.value.domain, "default_443_be_setting"])

      default_backend_address_pool_name = join("-", [url_path_map.value.domain, "default_be_pool"])

      default_rewrite_rule_set_name = try(url_path_map.value.default_rewrite_rule_set_name, null)

      dynamic "path_rule" {
        for_each = { for index, pool in local.list_of_backend_pools_to_create : format("%03d", index) => pool if url_path_map.value.domain == pool.backend_public_domain }
        content {
          name = join("_", [path_rule.value.backend_name, "path_rule_443"])

          paths = path_rule.value.backend_paths

          backend_address_pool_name = join("-", [path_rule.value.backend_name, "be-pool"])

          backend_http_settings_name = join("_", [path_rule.value.backend_name, "443_be_setting"])

          rewrite_rule_set_name = path_rule.value.rewrite_rule_set_name == "" ? null : path_rule.value.rewrite_rule_set_name
        }
      }
    }
  }

  # Basic Domain Based Routing Rules - p = 4n - 3
  dynamic "request_routing_rule" {
    for_each = { for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }
    content {
      name = join("_", [request_routing_rule.value.domain, "80_route_rule"])

      rule_type = "Basic"

      http_listener_name = join("_", [request_routing_rule.value.domain, "80"])

      redirect_configuration_name = join("-", [var.agw_name, request_routing_rule.value.domain, "redir-config"])

      priority = (4 * (request_routing_rule.key + (request_routing_rule.key + 1))) - 3
    }
  }

  # Basic Domain Based Routing Rules - p = 4n - 2
  dynamic "request_routing_rule" {
    for_each = { for index, listener in var.http_listeners_domain_based : format("%03d", index) => listener }
    content {
      name = join("_", [request_routing_rule.value.domain, "443_route_rule"])

      rule_type = "Basic"

      http_listener_name = join("_", [request_routing_rule.value.domain, "443"])

      backend_address_pool_name = join("-", [request_routing_rule.value.backend_pool_name, "be-pool"])

      backend_http_settings_name = join("_", [request_routing_rule.value.domain, request_routing_rule.value.backend_port, "be_setting"])

      priority = (4 * (request_routing_rule.key + (request_routing_rule.key + 1))) - 2

      rewrite_rule_set_name = try(request_routing_rule.value.rewrite_rule_set_name, null)
    }
  }

  # URL Map Path Based Routing Rules - p = 4n - 1
  dynamic "request_routing_rule" {
    for_each = { for index, listener in var.http_listeners_path_based : index => listener }
    content {

      name = join("_", [request_routing_rule.value.domain, "80_route_rule"])

      rule_type = "PathBasedRouting"

      http_listener_name = join("_", [request_routing_rule.value.domain, "80"])

      url_path_map_name = join("_", [request_routing_rule.value.domain, "url_path_map_80"])

      priority = (4 * (request_routing_rule.key + (request_routing_rule.key + 1))) - 1

    }
  }

  # URL Map Path Based Routing Rules - p = 4n
  dynamic "request_routing_rule" {
    for_each = { for index, listener in var.http_listeners_path_based : index => listener }
    content {
      name = join("_", [request_routing_rule.value.domain, "443_route_rule"])

      rule_type = "PathBasedRouting"

      http_listener_name = join("_", [request_routing_rule.value.domain, "443"])

      url_path_map_name = join("_", [request_routing_rule.value.domain, "url_path_map_443"])

      priority = (4 * (request_routing_rule.key + (request_routing_rule.key + 1)))
    }
  }

  # Specifying the instance_count variable will override the default of 2 instances
  # A default of 2 instances will always be created
  sku {
    name     = var.agw_sku
    tier     = var.agw_sku
    capacity = var.enable_autoscaling == false ? var.default_gateway_instance_count : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.enable_autoscaling == true ? [0] : []
    content {
      min_capacity = var.default_gateway_instance_count
      max_capacity = var.maximum_gateway_instance_count
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = try({ for ruleset in var.rewrite_rule_sets : ruleset.ruleset_name => ruleset }, {})

    content {

      name = rewrite_rule_set.value.ruleset_name

      dynamic "rewrite_rule" {
        for_each = { for rule in rewrite_rule_set.value.rewrite_rules : rule.name => rule }

        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = { for index, condition in rewrite_rule.value.condition : index => condition }

            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }

          }

          dynamic "request_header_configuration" {
            for_each = try({ for index, header_config in rewrite_rule.value.request_header_configuration : index => header_config }, {})

            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }

          }

          dynamic "response_header_configuration" {
            for_each = try({ for index, header_config in rewrite_rule.value.response_header_configuration : index => header_config }, {})

            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }

          }
        }

      }


    }
  }

  depends_on = [
    azurerm_user_assigned_identity.agw_uaid,
    azurerm_key_vault_access_policy.kv_policy,
    azurerm_role_assignment.kv_rbac_certificate,
    azurerm_role_assignment.kv_rbac_secret,
    azurerm_web_application_firewall_policy.waf
  ]

  tags = var.tags

}


resource "azurerm_monitor_diagnostic_setting" "agw_diag" {
  count = var.enable_gateway_diagnostic_logs ? 1 : 0

  name = join("_", [var.agw_name, "terraform_diagnostics"])

  target_resource_id = azurerm_application_gateway.appgw.id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }

  depends_on = [azurerm_application_gateway.appgw]

}

resource "azurerm_web_application_firewall_policy" "waf" {
  count = var.agw_sku == "WAF_v2" ? 1 : 0

  name = join("-", ["waf", var.agw_name])

  resource_group_name = var.rsg_name

  location = var.az_region

  tags = var.tags

  policy_settings {
    enabled                     = true
    mode                        = var.waf_mode
    file_upload_enforcement     = var.waf_file_upload_enforcement
    request_body_check          = var.waf_request_body_check
    max_request_body_size_in_kb = var.waf_max_request_body_size_in_kb

    dynamic "log_scrubbing" {
      for_each = var.enable_log_scrubbing == true ? [0] : []

      content {
        enabled = var.enable_log_scrubbing
        dynamic "rule" {
          for_each = try({ for index, rule in var.log_scrubbing_rules : index => rule }, {})

          content {
            enabled                 = rule.value.enabled
            match_variable          = rule.value.match_variable
            selector_match_operator = rule.value.selector_match_operator
            selector                = rule.value.selector
          }
        }
      }
    }
  }

  dynamic "custom_rules" {
    for_each = try({ for rule in var.waf_custom_rules : rule.name => rule }, {})
    content {
      name                 = custom_rules.value.name
      action               = custom_rules.value.action
      enabled              = try(custom_rules.value.enabled, true)
      priority             = custom_rules.value.priority
      rate_limit_duration  = try(custom_rules.value.rate_limit_duration, null)
      rate_limit_threshold = try(custom_rules.value.rate_limit_threshold, null)
      rule_type            = custom_rules.value.rule_type
      group_rate_limit_by  = try(custom_rules.value.group_rate_limit_by, null)
      dynamic "match_conditions" {
        for_each = try({ for index, condition in custom_rules.value.match_conditions : index => condition }, {})
        content {
          match_values       = try(match_conditions.value.match_values, null)
          operator           = match_conditions.value.operator
          negation_condition = try(match_conditions.value.negation_condition, null)
          transforms         = try(match_conditions.value.transforms, null)

          dynamic "match_variables" {
            for_each = try({ for match_variable in match_conditions.value.match_variables : match_variable.variable_name => match_variable }, {})

            content {
              variable_name = match_variables.value.variable_name
              selector      = try(match_variables.value.selector, null)
            }
          }
        }
      }
    }
  }

  managed_rules {

    dynamic "managed_rule_set" {
      for_each = try({ for index, rule in var.waf_managed_rule_sets : index => rule }, {})

      content {
        type    = managed_rule_set.value.type
        version = managed_rule_set.value.version

        dynamic "rule_group_override" {
          for_each = try({ for rule_group_override in managed_rule_set.value.rule_group_override : rule_group_override.rule_group_name => rule_group_override }, {})

          content {
            rule_group_name = rule_group_override.value.rule_group_name

            dynamic "rule" {
              for_each = try({ for rule in rule_group_override.value.rule : rule.id => rule }, {})

              content {
                id      = rule.value.id
                enabled = rule.value.enabled
                action  = rule.value.action
              }
            }
          }
        }
      }
    }


    dynamic "exclusion" {
      for_each = try({ for index, exclusion in var.waf_managed_rule_exclusions : index => exclusion }, {})
      content {
        match_variable          = exclusion.value.match_variable
        selector                = exclusion.value.selector
        selector_match_operator = exclusion.value.selector_match_operator

        dynamic "excluded_rule_set" {
          for_each = try({ for index, excluded_rule_set in exclusion.value.excluded_rule_set : index => excluded_rule_set }, {})
          content {
            type    = excluded_rule_set.value.type
            version = excluded_rule_set.value.version
            dynamic "rule_group" {
              for_each = try({ for rule_group in excluded_rule_set.value.rule_group : rule_group.rule_group_name => rule_group }, {})

              content {
                rule_group_name = rule_group.value.name
                excluded_rules  = rule_group.value.excluded_rules
              }
            }
          }

        }
      }
    }

  }
}

