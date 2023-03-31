module "base_infra" {
  source = "../../super_modules/base_infra"

  environment = "sandbox"
  organization = "pnlabs"

  location = "northcentralus"

  hub_vnet_address_space = ["10.10.0.0/24"]
  hub_subnet_address_prefix = ["10.10.0.0/28"]

  spoke_vnet_address_space = ["10.10.1.0/24"]
  spoke_subnet_address_prefix = ["10.10.1.0/28"]

  custom_tags = {
    "Builtby" = "Patrick"
  }
}