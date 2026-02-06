variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation"
  default     = null
}
variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}

variable "enable_delete_lock" {
  type        = bool
  description = "Toggle to enable/disable resource group delete lock at the resource group scope"
  default     = false
}
