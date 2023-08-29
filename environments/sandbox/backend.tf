terraform {
  backend "azurerm" {
    resource_group_name  = "pnlabs-tfstate-rg"
    storage_account_name = "pnlabstfstatest"
    container_name       = "tfstate"
    key                  = "pnlabs.tfstate"
    snapshot             = true
  }
}