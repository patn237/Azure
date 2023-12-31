terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.50.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = ">=2.36.0"
    }
  }

  required_version = ">=1.0.4"
}

provider "azurerm" {
  features {}
}