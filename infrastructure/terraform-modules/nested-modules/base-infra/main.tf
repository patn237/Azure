module "rsg" {
  source = "../../modules/terraform-azurerm-rsg"

  rsg_name  = var.rsg_name
  az_region = var.az_region

  enable_delete_lock = var.enable_delete_lock

  tags = var.tags
}

module "vnet" {
  source = "../../modules/terraform-azurerm-virtual-network-w-peering"

  rsg_name  = module.rsg.name
  az_region = var.az_region

  vnet_name = var.vnet_name

  vnet_address_space = var.vnet_address_space

  vnet_peerings = var.vnet_peerings

  tags = var.tags
}

module "snet" {
  source = "../../modules/terraform-azurerm-subnet-nsg"

  for_each = { for subnet in var.subnets : subnet.subnet_name => subnet }

  az_region = var.az_region
  rsg_name  = module.rsg.name
  vnet_name = module.vnet.vnet_name

  subnet_name     = each.value.subnet_name
  subnet_prefixes = each.value.subnet_prefixes

  service_endpoints = each.value.service_endpoints

  enable_subnet_delegation = each.value.enable_subnet_delegation

  override_naming_convention = each.value.subnet_overrides.override_naming_convention

  private_endpoint_network_policies = each.value.private_endpoint_network_policies

  delegation_name = each.value.delegation_name

  services_to_delegate = each.value.services_to_delegate

  delegation_actions = each.value.actions

  enable_subnet_nsg = each.value.subnet_overrides.create_subnet_nsg

  nsg_rules = try(each.value.subnet_nsg_rules, [])

  tags = var.tags
}

module "udr" {
  source   = "../../modules/terraform-azurerm-udr"
  for_each = { for route_table in var.route_tables : route_table.route_table_name => route_table }

  rt_name = each.key

  az_region = var.az_region
  rsg_name  = module.rsg.name

  udr_routes = each.value.udr_routes

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each = { for subnet in var.subnets : subnet.subnet_name => subnet if subnet.subnet_overrides.udr_association == true }

  subnet_id      = join(",", module.snet[each.value.subnet_name].subnet_id)
  route_table_id = module.udr[each.value.subnet_overrides.udr_name_to_associate_to].rt_table_id

  depends_on = [
    module.udr,
    module.snet
  ]
}