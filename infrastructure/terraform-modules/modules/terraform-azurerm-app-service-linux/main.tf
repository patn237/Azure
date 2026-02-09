resource "azurerm_linux_web_app" "linux" {
  name                = var.name
  location            = var.az_region
  resource_group_name = var.rsg_name
  service_plan_id     = var.asp_id

  # Support for Only a few properties have been configured. 
  # Additional app service properties can be configured as below.
  site_config {
    always_on = try(var.site_configs.always_on, false)

    # Support only for dotnet and/or node applications.
    # The docker configs can be specified but with a generic image and tag if a pipeline will override this. 
    # Terraform has been configured to ignore this config for the linux apps
    application_stack {
      dotnet_version           = try(var.site_configs.dotnet_version, null)
      node_version             = try(var.site_configs.node_version, null)
      docker_image_name        = try(var.site_configs.docker_image_name, null)
      docker_registry_url      = try(var.site_configs.docker_registry_url, null)
      docker_registry_username = try(var.site_configs.docker_registry_username, null)
      docker_registry_password = try(var.site_configs.docker_registry_password, null)
      php_version              = try(var.site_configs.php_version, null)
    }
    container_registry_use_managed_identity = var.container_registry_use_managed_identity
    dynamic "cors" {
      for_each = toset(var.cors_allowed_origins == null ? ["1"] : [])
      content {
        allowed_origins     = var.cors_allowed_origins
        support_credentials = var.cors_support_credentials
      }
    }

    default_documents                 = try(var.site_configs.default_documents_in_use, null)
    ftps_state                        = "FtpsOnly"
    health_check_path                 = try(var.site_configs.health_check_path, null)
    health_check_eviction_time_in_min = try(lookup(var.site_configs, "health_check_path"), null) == null ? null : 10
    http2_enabled                     = true
    minimum_tls_version               = try(var.site_configs.minimum_tls_version, 1.2)
    use_32_bit_worker                 = try(var.site_configs.use_32_bit_worker, false)

    vnet_route_all_enabled = true

    ip_restriction_default_action = "Deny"

    dynamic "ip_restriction" {
      for_each = try({ for acl in var.ip_restrictions : acl.ip_restriction_name => acl }, {})
      content {
        action     = ip_restriction.value.default_action
        ip_address = ip_restriction.value.public_ip
        name       = ip_restriction.value.ip_restriction_name
        priority   = ip_restriction.value.priority
      }
    }

    websockets_enabled = try(var.site_configs.websockers_enabled, null)

  }

  dynamic "auth_settings_v2" {
    for_each = toset(var.enable_auth_settings == true ? ["1"] : [])

    content {
      auth_enabled = var.enable_auth_settings == true ? true : false
      default_provider = "azureactivedirectory"
      runtime_version = "~1"
      unauthenticated_action = "RedirectToLoginPage"
      require_authentication = true

      active_directory_v2 {
        client_id = var.app_registration_client_id
        tenant_auth_endpoint = var.tenant_auth_endpoint
        client_secret_setting_name = var.client_secret_setting_name
        allowed_applications = var.allowed_applications
        allowed_audiences = var.allowed_audiences
      }

      login {
        token_store_enabled = true
      }

      excluded_paths = var.auth_settings_excluded_paths
    }
  }

  dynamic "identity" {
    for_each = toset(var.enable_system_identity == true ? ["1"] : [])
    content {
      type = "SystemAssigned"
    }
  }

  https_only = true

  logs {
    detailed_error_messages = true

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }

    failed_request_tracing = true
  }

  dynamic "storage_account" {
    for_each = var.mounted_storage_accounts == [] ? {} : ({ for storage in var.mounted_storage_accounts : storage.name => storage })

    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = storage_account.value.account_name
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      mount_path   = storage_account.value.mount_path == "" ? null : storage_account.value.mount_path
    }
  }

  app_settings = var.app_settings == [{}] ? {} : { for setting in var.app_settings : setting.name => setting.value }

  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode

  # Only applicable if the app service does not exist in the app service environment
  virtual_network_subnet_id = var.virtual_network_subnet_id

  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      backup,
      auth_settings_v2[0].active_directory_v2[0].allowed_audiences,
      client_certificate_enabled, # Accommodating JnJ Azure Policies
      client_certificate_mode # Accommodating JnJ Azure Policies      
    ]
  }

  tags = var.tags

}

resource "azurerm_app_service_custom_hostname_binding" "hostname" {
  count            = var.custom_domain != null ? 1 : 0

  hostname            = var.custom_domain
  app_service_name    = azurerm_linux_web_app.linux.name
  resource_group_name = var.rsg_name

  lifecycle {
    prevent_destroy = true # Adding these in as JnJ strips off the custom domain dns record post creation.
  }

}

resource "azurerm_app_service_certificate" "certificate" {
  count            = var.public_certificate != null ? 1 : 0

  name = var.public_certificate.certificate_name
  
  resource_group_name = var.rsg_name
  
  location = var.az_region
  
  pfx_blob = var.public_certificate.certificate_pfx_base64_blob == "" ? null : var.public_certificate.certificate_pfx_base64_blob
  
  password = var.public_certificate.certificate_pfx_password == "" ? null : var.public_certificate.certificate_pfx_password

  app_service_plan_id = var.asp_id

  key_vault_id = var.public_certificate.key_vault_id == "" ? null : var.public_certificate.key_vault_id

  key_vault_secret_id = var.public_certificate.key_vault_secret_id == "" ? null : var.public_certificate.key_vault_secret_id

  tags = var.tags
  
  depends_on = [ azurerm_linux_web_app.linux ]
}

resource "azurerm_app_service_certificate_binding" "cert_binding" {
  count            = var.enable_certificate_binding ? 1 : 0
  
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname[0].id
  
  certificate_id = azurerm_app_service_certificate.certificate[0].id
  
  ssl_state = "SniEnabled"

  depends_on = [ 
    azurerm_app_service_custom_hostname_binding.hostname,
    azurerm_app_service_certificate.certificate
   ]

}

# resource "azurerm_app_service_slot_custom_hostname_binding" "hostname" {
#   for_each            = var.create_pipeline == true ? { for domain in var.custom_domains : domain.hostname => domain } : {}
#   hostname            = each.value.hostname
#   app_service_slot_id = azurerm_linux_web_app_slot.linux[0].id
#   ssl_state           = lookup(each.value, "certificate_thumbprint", null) == null ? null : "SniEnabled"
#   thumbprint          = lookup(each.value, "certificate_thumbprint", null)
# }

resource "azurerm_linux_web_app_slot" "linux" {
  count          = (var.create_pipeline == true) ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.linux.id

  # Support for Only a few properties have been configured. 
  # Additional app service properties can be configured as below.
  site_config {
    always_on = try(var.site_configs.always_on, false)

    # Support only for dotnet and/or node applications.
    # The docker configs can be specified but with a generic image and tag if a pipeline will override this. 
    # Terraform has been configured to ignore this config for the linux apps
    application_stack {
      dotnet_version           = try(var.site_configs.dotnet_version, null)
      node_version             = try(var.site_configs.node_version, null)
      docker_image_name        = try(var.site_configs.docker_image_name, null)
      docker_registry_url      = try(var.site_configs.docker_registry_url, null)
      docker_registry_username = try(var.site_configs.docker_registry_username, null)
      docker_registry_password = try(var.site_configs.docker_registry_password, null)
      php_version              = try(var.site_configs.php_version, null)
    }
    container_registry_use_managed_identity = var.container_registry_use_managed_identity
    dynamic "cors" {
      for_each = toset(var.cors_allowed_origins == null ? ["1"] : [])
      content {
        allowed_origins     = var.cors_allowed_origins
        support_credentials = var.cors_support_credentials
      }
    }

    default_documents                 = try(var.site_configs.default_documents_in_use, null)
    ftps_state                        = "FtpsOnly"
    health_check_path                 = try(var.site_configs.health_check_path, null)
    health_check_eviction_time_in_min = try(lookup(var.site_configs, "health_check_path"), null) == null ? null : 10
    http2_enabled                     = true
    minimum_tls_version               = try(var.site_configs.minimum_tls_version, 1.2)
    use_32_bit_worker                 = try(var.site_configs.use_32_bit_worker, false)

    vnet_route_all_enabled = true

    ip_restriction_default_action = "Deny"

    dynamic "ip_restriction" {
      for_each = try({ for acl in var.ip_restrictions : acl.ip_restriction_name => acl }, {})
      content {
        action     = ip_restriction.value.default_action
        ip_address = ip_restriction.value.public_ip
        name       = ip_restriction.value.ip_restriction_name
        priority   = ip_restriction.value.priority
      }
    }

    websockets_enabled = try(var.site_configs.websockers_enabled, null)

  }

  dynamic "identity" {
    for_each = toset(var.enable_system_identity == true ? ["1"] : [])
    content {
      type = "SystemAssigned"
    }
  }

  https_only = true

  logs {
    detailed_error_messages = true

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }

    failed_request_tracing = true
  }

  dynamic "storage_account" {
    for_each = var.mounted_storage_accounts == [] ? {} : ({ for storage in var.mounted_storage_accounts : storage.name => storage })

    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = storage_account.value.account_name
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      mount_path   = storage_account.value.mount_path == "" ? null : storage_account.value.mount_path
    }
  }

  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode

  # Only applicable if the app service does not exist in the app service environment
  virtual_network_subnet_id = var.virtual_network_subnet_id

  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      backup,
      auth_settings_v2[0].active_directory_v2[0].allowed_audiences,
    ]
  }

  tags = var.tags

}

resource "azurerm_monitor_diagnostic_setting" "app_diag_setting" {
  name                       = "app_service_diagnostics_logs"
  target_resource_id         = azurerm_linux_web_app.linux.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  enabled_log {
    category = "AppServiceAppLogs"
  }
  enabled_log {
    category = "AppServiceAuditLogs"
  }
  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }
  enabled_log {
    category = "AppServicePlatformLogs"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }

}

resource "azurerm_monitor_diagnostic_setting" "slot_diag_setting" {
  count                      = var.create_pipeline == true ? 1 : 0
  name                       = "app_service_diagnostics_logs"
  target_resource_id         = azurerm_linux_web_app_slot.linux[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  enabled_log {
    category = "AppServiceAppLogs"
  }
  enabled_log {
    category = "AppServiceAuditLogs"
  }
  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }
  enabled_log {
    category = "AppServicePlatformLogs"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }

}

resource "azurerm_private_endpoint" "endpoint" {
  for_each            = { for index, endpoint in var.private_endpoints : format("%02d", index) => endpoint }
  name                = join("-", [var.name, each.key, each.value.sub_resource_name, "ep"])
  location            = var.az_region
  resource_group_name = var.rsg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = join("-", [var.name, each.key, each.value.sub_resource_name, "pl-conn"])
    private_connection_resource_id = azurerm_linux_web_app.linux.id
    is_manual_connection           = false
    subresource_names              = [each.value.sub_resource_name]
  }


  private_dns_zone_group {
    name                 = each.value.dns_zone_group
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  tags = var.tags

  depends_on = [
    azurerm_linux_web_app.linux,
    azurerm_linux_web_app_slot.linux
  ]

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}
