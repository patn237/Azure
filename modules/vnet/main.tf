resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  location = var.location
  resource_group_name = var.rg_name
  address_space = var.vnet_address_space

  tags = merge(var.common_tags,var.custom_tags)
}