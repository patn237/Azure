output "rsg_id" {
  value = module.rsg.id
  description = "ID of the deployed resource group"
}

output "rsg_name" {
  value = module.rsg.name
  description = "Name of the deployed resource group"
}

output "vnet_name" {
  value       = module.vnet.vnet_name
  description = "Name of the deployed virtual network resource"
}

output "vnet_id" {
  value       = module.vnet.vnet_id
  description = "ID of the deployed virtual network resource"
}

output "subnets" {
  value       = module.snet
  description = "Parent map of all deployed subnets"
}

output "kv_id" {
  value = module.key_vault.id
  description = "ID of the deployed key vault resource"
}
output "kv_url" {
  value = module.key_vault.url
  description = "URL of the deployed key vault resource"
}
output "kv_name" {
  value = module.key_vault.name
  description = "Name of the deployed key vault resource"
}

output "stor_acc_id" {
  value = module.storage_account.stor_acc_id
  description = "ID of the deployed storage account resource"
}