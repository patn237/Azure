# Common variables
variable "common_tags" {
  type = map(string)
  description = "Tags that are common for all resources deployed."
  default = null
}
variable "custom_tags" {
  type = map(string)
  description = "Custom tags for specific resources."
  default = null
}
variable "rg_name" {
  type = string
  description = "The Name which should be used for this Resource Group."
}
variable "location" {
  type = string
  description = "The Azure Region where the Resource Group should exist."
}

# Virtual Network Variables
variable "vnet_name" {
  type = string
  description = "The name of the virtual network."
}
variable "vnet_address_space" {
  type = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space."
}
