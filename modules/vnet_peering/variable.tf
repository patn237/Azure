variable "rg_name" {
  type = string
  description = "The Name which should be used for this Resource Group."
}
variable "hub_vnet_name" {
  type = string
  description = "The name of the hub virtual network."
}
variable "spoke_vnet_name" {
  type = string
  description = "The name of the spoke virtual network."
}
variable "vnet_peer_hub-to-spoke_name" {
  type = string
  description = "The name of the virtual network peering."
}
variable "vnet_peer_spoke-to-hub_name" {
  type = string
  description = "The name of the virtual network peering."
}
variable "allow_virtual_network_access" {
  type = bool
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network."
}
variable "allow_forwarded_traffic" {
  type = bool
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
}
# variable "allow_gateway_transit" {
#   type = bool
#   description = "Controls gatewayLinks can be used in the remote virtual network's link to the local virtual network."
# }
# variable "use_remote_gateways" {
#   type = bool
#   description = "Controls if remote gateways can be used on the local virtual network."
# }
variable "hub_remote_vnet_id" {
  type = string
  description = "The full Azure resource ID of the remote virtual network."
}
variable "spoke_remote_vnet_id" {
  type = string
  description = "The full Azure resource ID of the remote virtual network."
}
