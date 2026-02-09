output "bh_id" {
  value = azurerm_bastion_host.bastion_host.id
}
output "bh_name" {
  value = azurerm_bastion_host.bastion_host.name
}
output "bh_public_ip" {
  value = azurerm_public_ip.bastion_host.id
}
output "bh_public_ip_name" {
  value = azurerm_public_ip.bastion_host.name
}