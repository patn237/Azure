resource "azurerm_resource_group" "rsg" {
  name     = var.rsg_name
  location = var.az_region

  tags = var.tags
}

resource "azurerm_management_lock" "rsg_lock" {
  count      = var.enable_delete_lock ? 1 : 0
  name       = join("_", [var.rsg_name, "lock"])
  scope      = azurerm_resource_group.rsg.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group is delete-locked by a terraform deployment"
}
