locals {
  common_tags = {
    "Environment" = var.environment
    "Organization" = var.organization
  }
}

module "resource_group" {
  source = "../../modules/rg"

  rg_name = join("-", [var.organization, var.environment, "rg"])
  location = var.location

  common_tags = local.common_tags
  custom_tags = var.custom_tags
}

module "virtual_network" {
  source = "../../modules/vnet"

  rg_name = module.resource_group.name
  location = var.location

  vnet_name = join("-", [var.organization, var.environment, "vnet"])
  
  vnet_address_space = var.vnet_address_space

  common_tags = local.common_tags
  custom_tags = var.custom_tags
}