variable "custom_tags" {
  type = map(string)
  description = "Custom tags for specific resources."
  default = null
}
variable "environment" {
  type = string
  description = "The type of environment the resources exist in."
}
variable "organization" {
  type = string
  description = "The name of the organization."
}
variable "location" {
  type = string
  description = "The Azure Region where the Resource Group should exist."
}
variable "hub_vnet_address_space" {
  type = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space."
}
variable "hub_subnet_address_prefix" {
  type = list(string)
  description = "The address prefixes to use for the subnet."
}
variable "spoke_vnet_address_space" {
  type = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space."
}
variable "spoke_subnet_address_prefix" {
  type = list(string)
  description = "The address prefixes to use for the subnet."
}