variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource"
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}

variable "domain_name_label" {
  description = "an A DNS record is created for the public IP in the Microsoft Azure DNS system"
  type        = string
  default     = null
}

variable "zones" {
  description = "A collection containing the availability zone to allocate the resources being deployed"
  type        = list(string)
  default     = null
}

variable "bastion_host_name" {
  type        = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
}

variable "allocation_method" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created."
  default     = "Static"
}

variable "public_ip_sku" {
  type        = string
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "bastion_host_sku" {
  type        = string
  description = "The SKU of the Bastion Host. Accepted values are Basic and Standard."
}
variable "bastion_host_subnet_id" {
  type        = string
  description = "(Required) Reference to a subnet in which this Bastion Host has been created. Changing this forces a new resource to be created."
}

variable "copy_paste_enabled" {
  type        = bool
  description = "(Optional) Is Copy/Paste feature enabled for the Bastion Host"
  default     = false
}

variable "file_copy_enabled" {
  type        = bool
  description = "(Optional) Is File Copy feature enabled for the Bastion Host"
  default     = false
}

variable "tunneling_enabled" {
  type        = bool
  description = "(Optional) Is Tunneling feature enabled for the Bastion Host"
  default     = false
}

variable "ip_connect_enabled" {
  type        = bool
  description = "(Optional) Is IP Connect feature enabled for the Bastion Host."
  default     = false
}

variable "kerberos_enabled" {
  type        = bool
  description = "(Optional) Is Kerberos authentication feature enabled for the Bastion Host."
  default     = false
}

variable "shareable_link_enabled" {
  type        = bool
  description = "(Optional) Is Shareable Link feature enabled for the Bastion Host."
  default     = false
}

variable "session_recording_enabled" {
  type        = bool
  description = "(Optional) Is Session Recording feature enabled for the Bastion Host."
  default     = false
}

variable "scale_units" {
  type        = number
  description = "(Optional) The number of scale units with which to provision the Bastion Host. Possible values are between 2 and 50"
  default     = 2
}
