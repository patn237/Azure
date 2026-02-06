variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}

variable "rt_name" {
  type        = string
  description = "The name of the route table group"
}

variable "udr_routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource"
}
