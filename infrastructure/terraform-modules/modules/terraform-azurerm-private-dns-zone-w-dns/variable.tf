variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation"
  default     = null
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
  default     = "WestUS"
}
variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}
variable "dns_zones" {
  type = list(object({
    dns_zone              = string
    dns_auto_registration = bool
    dns_records = list(object({
      name         = string
      ttl          = number
      ip_addresses = optional(list(string))
      cname_record = optional(string)
      type         = string
    }))
  }))
  description = "Specifies a list of private dns zones to create"
  default     = []
}

variable "link_hub_vnet_id" {
  type        = string
  description = "The Hub VNET ID to be linked with the private zone"
}

variable "list_of_spoke_vnet_ids_for_dns_link" {
  type        = list(string)
  description = "A list of string used to link more spoke virtual networks to the deployed private dns zones"
  default     = []
}
