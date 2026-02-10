module "private_dns_zones" {
  source = "../terraform-modules/modules/terraform-azurerm-private-dns-zone-w-dns"

  rsg_name = module.hello_world_base_infra.rsg_name

  link_hub_vnet_id = module.hello_world_base_infra.vnet_id

  dns_zones = [
    {
      dns_zone              = "privatelink.blob.core.windows.net"
      dns_auto_registration = false
      dns_records           = []
    },
    {
      dns_zone              = "privatelink.file.core.windows.net"
      dns_auto_registration = false
      dns_records           = []
    },
    {
      dns_zone              = "privatelink.vaultcore.azure.net"
      dns_auto_registration = false
      dns_records           = []
    }
  ]

  tags = local.tags
}