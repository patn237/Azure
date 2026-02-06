module "dev_base_infra" {
  source = "../terraform-modules/nested-modules/base-infra"

  rsg_name  = join("-", ["rg", local.resource_names])
  az_region = local.az_region

  enable_delete_lock = false

  vnet_name = join("-", ["vnet", local.resource_names])

  vnet_address_space = ["10.0.100.0/24"]

  vnet_peerings = []

  subnets = [
    {
      subnet_name       = "endpoints"
      subnet_prefixes   = ["10.0.100.0/27"]
      service_endpoints = []
      subnet_overrides = {
        override_naming_convention = false
        create_subnet_nsg          = true
      }
    },
  ]


  tags = local.tags
}