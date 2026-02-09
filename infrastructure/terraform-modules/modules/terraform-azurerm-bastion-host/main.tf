resource "azurerm_public_ip" "bastion_host" {
  name = join("-", ["pip", var.bastion_host_name])

  resource_group_name = var.rsg_name

  location = var.az_region

  allocation_method = var.allocation_method

  sku = var.public_ip_sku

  domain_name_label = var.domain_name_label

  zones = var.zones == null ? null : var.zones

  tags = var.tags
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  resource_group_name = var.rsg_name
  location            = var.az_region
  tags                = var.tags

  sku                = var.bastion_host_sku
  copy_paste_enabled = var.copy_paste_enabled
  file_copy_enabled  = var.file_copy_enabled
  tunneling_enabled  = var.tunneling_enabled #Required for native client support


  ip_configuration {
    name                 = join("_", [var.bastion_host_name, "ipConfig"])
    subnet_id            = var.bastion_host_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_host.id
  }

  ip_connect_enabled = var.ip_connect_enabled

  kerberos_enabled = var.kerberos_enabled

  shareable_link_enabled = var.shareable_link_enabled

  session_recording_enabled = var.session_recording_enabled

  zones = var.zones == null ? null : var.zones

  scale_units = var.scale_units
}
