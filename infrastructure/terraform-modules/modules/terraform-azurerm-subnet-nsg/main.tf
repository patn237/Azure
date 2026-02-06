locals {
  subnet_name          = substr(var.subnet_name, 0, 50)
  subnet_resource_type = "snet"
  nsg_resource_type    = "nsg"
}


resource "azurerm_subnet" "subnet" {
  name = (var.override_naming_convention == true) ? var.subnet_name : join("-", [local.subnet_resource_type, local.subnet_name])

  resource_group_name = var.rsg_name

  virtual_network_name = var.vnet_name

  address_prefixes = var.subnet_prefixes

  service_endpoints = var.service_endpoints == "" ? null : var.service_endpoints

  private_endpoint_network_policies = var.private_endpoint_network_policies

  private_link_service_network_policies_enabled = true

  dynamic "delegation" {
    for_each = toset(var.enable_subnet_delegation ? ["1"] : [])

    content {
      name = var.enable_subnet_delegation == true && var.delegation_name == null ? "delegation" : var.delegation_name

      service_delegation {
        name    = var.services_to_delegate
        actions = var.delegation_actions
      }
    }
  }

}

resource "azurerm_network_security_group" "nsg" {
  count               = var.enable_subnet_nsg ? 1 : 0
  name                = join("-", [local.nsg_resource_type, local.subnet_resource_type, local.subnet_name])
  location            = var.az_region
  resource_group_name = var.rsg_name

  tags = var.tags

  depends_on = [
    azurerm_subnet.subnet
  ]
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each  = try({ for rule in var.nsg_rules : rule.name => rule if(var.enable_subnet_nsg == true) }, [])
  name      = each.value.name
  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  source_port_range = each.value.source_port_ranges == "" ? null : each.value.source_port_ranges

  destination_port_range = each.value.destination_port_range == "" ? null : each.value.destination_port_range

  destination_port_ranges = length(each.value.destination_port_ranges) > 0 ? split(",", each.value.destination_port_ranges) : null

  source_address_prefix = each.value.source_address_prefix == "" ? null : each.value.source_address_prefix

  source_address_prefixes = length(each.value.source_address_prefixes) > 0 ? split(",", replace(each.value.source_address_prefixes, " ", "")) : null

  destination_address_prefix = each.value.destination_address_prefix == "" ? null : each.value.destination_address_prefix

  destination_address_prefixes = length(each.value.destination_address_prefixes) > 0 ? split(",", replace(each.value.destination_address_prefixes, " ", "")) : null

  resource_group_name         = var.rsg_name
  network_security_group_name = try(azurerm_network_security_group.nsg.0.name, null)

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  count                     = var.enable_subnet_nsg ? 1 : 0
  network_security_group_id = azurerm_network_security_group.nsg.0.id
  subnet_id                 = azurerm_subnet.subnet.id

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet,
    azurerm_network_security_rule.nsg_rule
  ]
}
