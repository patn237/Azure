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

module "virtual_network_hub" {
  source = "../../modules/vnet"

  rg_name = module.resource_group.name
  location = var.location

  vnet_name = join("-", [var.organization, var.environment, "vnet-hub"])
  
  vnet_address_space = var.hub_vnet_address_space

  common_tags = local.common_tags
  custom_tags = var.custom_tags
}

module "subnet_hub" {
  source = "../../modules/subnets"

  rg_name = module.resource_group.name
  vnet_name = module.virtual_network_hub.name

  subnet_name = join("-", [var.organization, var.environment, "snet-hub"])
  subnet_address_prefix = var.hub_subnet_address_prefix
}

module "virtual_network_spoke" {
  source = "../../modules/vnet"

  rg_name = module.resource_group.name
  location = var.location

  vnet_name = join("-", [var.organization, var.environment, "vnet-spoke"])
  
  vnet_address_space = var.spoke_vnet_address_space

  common_tags = local.common_tags
  custom_tags = var.custom_tags
}

module "subnet_spoke" {
  source = "../../modules/subnets"

  rg_name = module.resource_group.name
  vnet_name = module.virtual_network_spoke.name

  subnet_name = join("-", [var.organization, var.environment, "snet-spoke"])
  subnet_address_prefix = var.spoke_subnet_address_prefix
}

module "vnet_peering" {
  source = "../../modules/vnet_peering"

  rg_name = module.resource_group.name

  hub_vnet_name = module.virtual_network_hub.name
  spoke_vnet_name = module.virtual_network_spoke.name

  vnet_peer_hub-to-spoke_name = join("-", [module.virtual_network_hub.name, "to", module.virtual_network_spoke.name])
  vnet_peer_spoke-to-hub_name = join("-", [module.virtual_network_spoke.name, "to", module.virtual_network_hub.name])

  hub_remote_vnet_id = module.virtual_network_hub.id
  spoke_remote_vnet_id = module.virtual_network_spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}