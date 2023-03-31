resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.location

  tags = merge(var.common_tags,var.custom_tags)
}