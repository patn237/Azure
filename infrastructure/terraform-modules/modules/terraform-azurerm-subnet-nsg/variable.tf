variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}
variable "vnet_name" {
  type        = string
  description = "Name of the vnet where the subnet will reside"
}
variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "IP CIDR for the new subnet"
}
variable "service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet. "
  default     = null
}
variable "private_endpoint_network_policies" {
  type        = string
  description = "Enable or Disable network policies for the private endpoint on the subnet. Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled."
  default     = "NetworkSecurityGroupEnabled"
}

variable "enable_subnet_delegation" {
  type        = bool
  description = "Toggle to Enable/Disable Subnet Delegation"
  default     = false
}

variable "delegation_name" {
  type        = string
  description = "Subnet Delegation Name"
  default     = null
}

variable "services_to_delegate" {
  type        = string
  description = "A name for this delegation."
  default     = null
}
variable "delegation_actions" {
  type        = list(string)
  description = "A list of Actions which should be delegated. This list is specific to the service to delegate to."
  default     = null
}

variable "nsg_rules" {
  type = list(object({
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
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource"
}

variable "override_naming_convention" {
  type        = bool
  description = "Toggle used to override the subnet naming convention"
}

variable "enable_subnet_nsg" {
  type        = bool
  description = "Toggle to create or skip nsg creation"
}
