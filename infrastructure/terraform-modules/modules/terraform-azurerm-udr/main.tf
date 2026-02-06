locals {
  rt_name       = substr(var.rt_name, 0, 50)
  resource_type = "rt"
}

#There might be multiple route tables created under same name as there can be multiple rt table under a application and environment
#It might be an better idea to pass in additional parameter in nested module for the naming convention to make it unique
resource "azurerm_route_table" "route_table" {
  name                          = join("-", [local.resource_type, local.rt_name])
  location                      = var.az_region
  resource_group_name           = var.rsg_name
  bgp_route_propagation_enabled = true

  route = []
  tags  = var.tags

  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

resource "azurerm_route" "udr_route" {
  for_each               = var.udr_routes == null ? {} : { for route in var.udr_routes : route.name => route }
  name                   = each.value.name
  resource_group_name    = var.rsg_name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address == "" ? null : each.value.next_hop_in_ip_address


  depends_on = [
    azurerm_route_table.route_table
  ]
}
