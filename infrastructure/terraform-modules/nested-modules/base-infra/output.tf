output "rsg_id" {
  value = module.rsg.id
}

output "rsg_name" {
  value = module.rsg.name
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