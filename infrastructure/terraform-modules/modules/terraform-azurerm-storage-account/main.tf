resource "azurerm_storage_account" "storage" {
  name                             = var.stor_acc_name
  resource_group_name              = var.rsg_name
  location                         = var.az_region
  account_kind                     = var.kind
  account_tier                     = var.tier
  account_replication_type         = var.replication_type
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  cross_tenant_replication_enabled = false
  shared_access_key_enabled        = var.enable_access_with_shared_access_key

  public_network_access_enabled = false

  dynamic "share_properties" {
    for_each = var.enable_file_share == true ? [1] : []
    content {
      retention_policy {
        days = 14
      }
    }

  }

  dynamic "network_rules" {
    for_each = var.enable_network_rules == false ? [] : [1]
    content {
      default_action             = var.enable_network_rules == true ? var.default_network_rule_action : null
      ip_rules                   = var.enable_network_rules == true ? var.public_ips : null
      virtual_network_subnet_ids = var.enable_network_rules == true ? var.virtual_network_subnet_ids : null
      bypass                     = var.enable_network_rules == true ? var.traffic_bypass : null
    }
  }

  dynamic "blob_properties" {
    for_each = var.configure_blob_properties ? [1] : []

    content {
      dynamic "delete_retention_policy" {
        for_each = (var.configure_blob_properties && var.blob_delete_retention_days != null) ? [1] : []

        content {
          days = var.blob_delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = (var.configure_blob_properties && var.container_delete_retention_days != null) ? [1] : []

        content {
          days = var.container_delete_retention_days
        }
      }


      versioning_enabled = try(var.enable_blob_versioning, null)

      change_feed_enabled = try(var.enable_change_feed, null)

      change_feed_retention_in_days = var.enable_change_feed ? try(var.change_feed_retention_days, null) : null
    }
  }

  tags = var.tags

}

resource "azurerm_storage_share" "share" {
  for_each = try({ for share in var.file_shares : share.file_share_name => share }, {})

  name               = each.value.file_share_name
  storage_account_id = azurerm_storage_account.storage.id
  quota              = each.value.file_share_quota_gb

  depends_on = [
    azurerm_storage_account.storage
  ]
}

resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.blob_containers)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.storage
  ]
}

resource "azurerm_private_endpoint" "endpoint" {
  for_each            = try({ for index, endpoint in var.private_endpoints : format("%02d", index) => endpoint }, {})
  name                = join("-", [var.stor_acc_name, each.key, each.value.sub_resource_name, "ep"])
  location            = var.az_region
  resource_group_name = var.rsg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = join("-", [var.stor_acc_name, each.key, each.value.sub_resource_name, "pl-conn"])
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = [each.value.sub_resource_name]
  }

  private_dns_zone_group {
    name                 = each.value.dns_zone_group
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  tags = var.tags

  depends_on = [
    azurerm_storage_account.storage
  ]

}
