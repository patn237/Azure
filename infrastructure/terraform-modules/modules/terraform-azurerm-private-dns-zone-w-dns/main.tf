locals {
  dns_zones = { for zone in var.dns_zones : zone.dns_zone => zone }

  dns_records = flatten([for zone, zone_settings in local.dns_zones :
    [for dns_records, records in zone_settings.dns_records :
      {
        record_name  = records.name
        record_type  = records.type
        ttl          = records.ttl
        ip_addresses = records.ip_addresses
        zone_name    = zone_settings.dns_zone
        cname_record = records.cname_record
  }]])

  spokes_to_zone_link = flatten([for vnet in var.list_of_spoke_vnet_ids_for_dns_link :
    [for zone in var.dns_zones :
      {
        dns_zone              = zone.dns_zone
        vnet_id               = vnet
        dns_auto_registration = zone.dns_auto_registration
      }
    ]
  ])
}

resource "azurerm_private_dns_zone" "zone" {
  for_each            = { for zone in var.dns_zones : zone.dns_zone => zone }
  name                = each.value.dns_zone
  resource_group_name = var.rsg_name

  tags = var.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each              = { for zone in var.dns_zones : zone.dns_zone => zone }
  name                  = join(".", [each.value.dns_zone, "link"])
  resource_group_name   = var.rsg_name
  private_dns_zone_name = each.value.dns_zone
  virtual_network_id    = var.link_hub_vnet_id
  registration_enabled  = each.value.dns_auto_registration

  depends_on = [
    azurerm_private_dns_zone.zone
  ]

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_spokes" {
  for_each = { for link in local.spokes_to_zone_link : join("_", [basename(link.vnet_id), link.dns_zone]) => link }

  name = join("_", ["link", basename(each.value.vnet_id), "to", each.value.dns_zone])

  resource_group_name = var.rsg_name

  private_dns_zone_name = each.value.dns_zone

  virtual_network_id = each.value.vnet_id

  registration_enabled = each.value.dns_auto_registration

  depends_on = [
    azurerm_private_dns_zone.zone
  ]

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "records" {
  for_each = try({ for record in local.dns_records : record.record_name => record if record.record_type == "a_record" }, [])

  name                = each.value.record_name
  zone_name           = each.value.zone_name
  resource_group_name = var.rsg_name
  ttl                 = each.value.ttl
  records             = each.value.ip_addresses

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone.zone
  ]
}

resource "azurerm_private_dns_cname_record" "records" {
  for_each = try({ for record in local.dns_records : record.record_name => record if record.record_type == "cname_record" }, [])

  name                = each.value.record_name
  zone_name           = each.value.zone_name
  resource_group_name = var.rsg_name
  ttl                 = each.value.ttl
  record              = each.value.cname_record

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone.zone
  ]
}
