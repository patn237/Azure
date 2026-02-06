output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Name of the deployed virtual network resource"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of the deployed virtual network resource"
}
