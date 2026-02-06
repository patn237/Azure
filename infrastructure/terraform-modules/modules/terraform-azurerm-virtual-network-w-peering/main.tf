resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.az_region
  resource_group_name = var.rsg_name
  address_space       = var.vnet_address_space

  tags = var.tags

}

resource "azurerm_virtual_network_peering" "peer" {
  for_each = try({ for peering in var.vnet_peerings : peering.remote_vnet_name => peering }, {})
  name     = join("_", [var.vnet_name, "peerTo", each.value.remote_vnet_name])

  resource_group_name = var.rsg_name

  virtual_network_name = azurerm_virtual_network.vnet.name

  remote_virtual_network_id = each.value.remote_vnet_id

  allow_gateway_transit = each.value.allow_gateway_transit #Use this virtual network's gateway or Route Server

  allow_forwarded_traffic = each.value.allow_forwarded_traffic #Traffic forwarded from remote virtual network where traffic is not originated from remote

  use_remote_gateways = each.value.use_remote_gateways # Controls if remote gateways can be used on the local virtual network.



  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
