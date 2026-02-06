terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "3f7742d5-b983-414e-ae30-ea25b1180283" # Change as needed
}
