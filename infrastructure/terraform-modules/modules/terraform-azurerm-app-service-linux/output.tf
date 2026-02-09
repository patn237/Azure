output "name" {
  description = "ID of the Web Application"
  value       = azurerm_linux_web_app.linux.name
}

output "id" {
  description = "ID of the Web Application"
  value       = azurerm_linux_web_app.linux.id
}

output "default_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = azurerm_linux_web_app.linux.default_hostname
}

output "managed_identity" {
  description = "Principal ID of the Application's System Assigned Managed Identity"
  value       = var.enable_system_identity == true ? azurerm_linux_web_app.linux.identity.0.principal_id : null
}

output "slot_managed_identity" {
  description = "Principal ID of the Application Slot's System Assigned Managed Identity"
  value       = var.create_pipeline == true && var.enable_system_identity == true ? azurerm_linux_web_app_slot.linux[0].identity.0.principal_id : null
}

output "private_endpoint_private_ip_address" {
  description = "IP address of the private endpoints"
  value = try({ for index, endpoint in azurerm_private_endpoint.endpoint : index => endpoint[*].private_service_connection[0].private_ip_address }, null)
}