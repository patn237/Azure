variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation."
  default     = null
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created."
}

variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created."
}

variable "enable_delete_lock" {
  type        = bool
  description = "Toggle to enable/disable resource group delete lock at the resource group scope."
  default     = false
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
  description = "A List of objects used to configure Virtual Network Peerings against the deployed Virtual Network."
}

variable "subnets" {
  type = list(object({
    subnet_name                       = string
    subnet_prefixes                   = list(string)
    service_endpoints                 = optional(list(string), [])
    enable_subnet_delegation          = optional(bool, false)
    delegation_name                   = optional(string, null)
    services_to_delegate              = optional(string, null)
    actions                           = optional(list(string), null)
    private_endpoint_network_policies = optional(string, "NetworkSecurityGroupEnabled")
    subnet_overrides = object({
      override_naming_convention     = optional(bool, false)
      create_subnet_nsg              = optional(bool, true)
      inherit_landing_zone_nsg_rules = optional(bool, true)
      udr_association                = optional(bool, true)
      udr_name_to_associate_to       = optional(string)
    })
    subnet_nsg_rules = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_ranges           = string
      destination_port_range       = string
      destination_port_ranges      = string
      source_address_prefix        = string
      source_address_prefixes      = string
      destination_address_prefix   = string
      destination_address_prefixes = string
    })), [])
  }))
  description = "A list of objects used to configure the subnets created within the virtual network."
}
