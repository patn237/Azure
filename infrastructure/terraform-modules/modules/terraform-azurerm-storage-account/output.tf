output "stor_acc_id" {
  value = azurerm_storage_account.storage.id
}
output "stor_acc_name" {
  value = azurerm_storage_account.storage.name
}
output "stor_pri_access_key" {
  value = azurerm_storage_account.storage.primary_access_key
}
output "stor_sec_access_key" {
  value = azurerm_storage_account.storage.secondary_access_key
}
output "stor_pri_hostname" {
  value = azurerm_storage_account.storage.primary_blob_host
}
output "stor_pri_blob_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "primary_connection_string" {
  value = azurerm_storage_account.storage.primary_connection_string
}