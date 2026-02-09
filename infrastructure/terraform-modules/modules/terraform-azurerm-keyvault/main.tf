resource "azurerm_key_vault" "vault" {
  name                            = var.name
  location                        = var.az_region
  resource_group_name             = var.rsg_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  rbac_authorization_enabled      = var.enable_rbac_authorization
  tenant_id                       = var.azurerm_tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  sku_name                        = var.keyvault_sku

  public_network_access_enabled = var.public_network_access_enabled


  dynamic "network_acls" {
    for_each = var.enable_network_acls == true ? [1] : []
    content {
      bypass                     = var.traffic_bypass
      default_action             = var.default_action #Azure API has limitations on the Keyvault Firewall - https://github.com/hashicorp/terraform-provider-azurerm/issues/9738
      ip_rules                   = var.public_ips
      virtual_network_subnet_ids = var.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "endpoint" {
  for_each            = { for index, endpoint in var.private_endpoints : format("%02d", index) => endpoint }
  name                = join("-", [var.name, each.key, each.value.sub_resource_name, "ep"])
  location            = var.az_region
  resource_group_name = var.rsg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = join("-", [var.name, each.key, each.value.sub_resource_name, "pl-conn"])
    private_connection_resource_id = azurerm_key_vault.vault.id
    is_manual_connection           = false
    subresource_names              = [each.value.sub_resource_name]
  }

  private_dns_zone_group {
    name                 = each.value.dns_zone_group
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  tags = var.tags

  depends_on = [
    azurerm_key_vault.vault
  ]
}

resource "azurerm_monitor_diagnostic_setting" "kv_diag" {
  count = var.enable_keyvault_diagnostic_logs ? 1 : 0

  name = join("_", [var.name, "terraform_diagnostics"])

  target_resource_id = azurerm_key_vault.vault.id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  depends_on = [azurerm_key_vault.vault]

}
