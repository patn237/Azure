module "base_infra" {
  source = "../../super_modules/base_infra"

  environment = "sandbox"
  organization = "pnlabs"

  location = "northcentralus"

  vnet_address_space = ["10.10.0.0/24"]

  custom_tags = {
    "Builtby" = "Patrick"
  }
}