resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name = var.vnet_peer_hub-to-spoke_name
  resource_group_name = var.rg_name
  virtual_network_name = var.hub_vnet_name
  remote_virtual_network_id = var.spoke_remote_vnet_id

  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic = var.allow_forwarded_traffic
  allow_gateway_transit = false
  use_remote_gateways = false
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name = var.vnet_peer_spoke-to-hub_name
  resource_group_name = var.rg_name
  virtual_network_name = var.spoke_vnet_name
  remote_virtual_network_id = var.hub_remote_vnet_id

  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic = var.allow_forwarded_traffic
  allow_gateway_transit = false
  use_remote_gateways = false
}