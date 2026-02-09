output "agw_id" {
  value       = azurerm_application_gateway.appgw.id
  description = "ID of the deployed application gateway"
}

output "agw_name" {
  value       = azurerm_application_gateway.appgw.name
  description = "Name of the deployed application gateway"
}

output "agw_pip" {
  value       = azurerm_public_ip.agw_pip.ip_address
  description = "IP address assigned to the application gateway"
}

output "agw_pip_id" {
  value       = azurerm_public_ip.agw_pip.id
  description = "ID of the deployed application gateway Public IP"
}
