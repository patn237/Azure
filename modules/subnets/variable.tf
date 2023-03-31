variable "rg_name" {
  type = string
  description = "The Name which should be used for this Resource Group."
}
variable "vnet_name" {
  type = string
  description = "The name of the virtual network."
}
variable "subnet_name" {
  type = string
  description = "The name of the subnet."
}
variable "subnet_address_prefix" {
  type = list(string)
  description = "The address prefixes to use for the subnet."
}