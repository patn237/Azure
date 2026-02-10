module "hello_world_base_infra" {
  source = "../terraform-modules/nested-modules/base-infra"

  rsg_name  = join("-", ["rg", local.resource_names])
  az_region = local.az_region

  enable_delete_lock = false

  vnet_name = join("-", ["vnet", local.resource_names])

  vnet_address_space = ["10.0.100.0/23"]

  vnet_peerings = []

  subnets = [
    {
      subnet_name       = "endpoints"
      subnet_prefixes   = ["10.0.101.0/27"]
      service_endpoints = []
      subnet_overrides = {
        override_naming_convention = false
        create_subnet_nsg          = true
        udr_association            = false
        udr_name_to_associate_to   = local.resource_names
      }
    },
  ]

  private_endpoint_subnet_name = "endpoints"

  azurerm_tenant_id = data.azurerm_client_config.current.tenant_id

  file_share_private_dns_zone_id = module.private_dns_zones.zone_ids["privatelink.file.core.windows.net"]
  blob_container_private_dns_zone_id = module.private_dns_zones.zone_ids["privatelink.blob.core.windows.net"]
  keyvault_private_dns_zone_id = module.private_dns_zones.zone_ids["privatelink.vaultcore.azure.net"]

  keyvault_name = join("", ["kv", replace(local.resource_names, "-", "")])

  storage_account_name = join("", ["st", replace(local.resource_names, "-", "")])

  storage_account_replication_type = "LRS"

  blob_containers = []

  tags = local.tags
}