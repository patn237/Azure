variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation"
  default     = null
}

variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "vnet_name" {
  type        = string
  description = "The name of the virtual network. Changing this forces a new resource to be created."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space."
}

variable "vnet_peerings" {
  type = list(object({
    remote_vnet_name        = string
    remote_vnet_id          = string
    allow_gateway_transit   = bool
    allow_forwarded_traffic = bool
    use_remote_gateways     = bool
  }))
  default     = []
  description = "A List of objects used to configure Virtual Network Peerings against the deployed Virtual Network"
}

