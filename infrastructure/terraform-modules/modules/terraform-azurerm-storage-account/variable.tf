variable "tags" {
  type        = map(string)
  description = "Map of tags to be appended to the resource group on creation"
}

variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}
variable "stor_acc_name" {
  type        = string
  description = "The name used for the Storage Account."
}
variable "kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
}
variable "tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
}
variable "replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Allow or disallow nested items within this Account to opt into being public."
  default     = false
}

variable "configure_blob_properties" {
  type        = bool
  description = "Toggle to enable blob properties for the azure storage account"
  default     = false
}
variable "blob_delete_retention_days" {
  type        = number
  description = "Specifies the number of days that the blobs should be retained"
  default     = 7
}

variable "container_delete_retention_days" {
  type        = number
  description = "Specifies the number of days that the containers should be retained"
  default     = 7
}

variable "change_feed_retention_days" {
  type        = number
  description = "The duration of change feed events retention in days. The possible values are between 1 and 146000 days (400 years). Not setting this value will indicate infinite change feed retention. "
  default     = null
}

variable "enable_blob_versioning" {
  type        = bool
  description = "Is blob versioning enabled?"
  default     = false
}

variable "enable_change_feed" {
  type        = bool
  description = "Is change feed enabled?"
  default     = false
}

variable "blob_containers" {
  type        = list(string)
  description = "List of storage account containers to create within the storage account"
  default     = []
}
variable "enable_file_share" {
  type        = bool
  default     = false
  description = "Toggle to enable/disable file share on this storage account"
}

variable "file_shares" {
  type = list(object({
    file_share_name     = string
    file_share_quota_gb = number
  }))
  description = "List of objects used to create file shares within the storage account"
  default     = []
}

variable "enable_network_rules" {
  type        = bool
  default     = false
  description = "Toggle to enable/disable firewall rules for this storage account"
}
variable "default_network_rule_action" {
  type        = string
  description = "Default Network Rule Action"
  default     = "Deny"
}

variable "enable_access_with_shared_access_key" {
  type        = bool
  default     = true
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key"
}
variable "public_ips" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed."
  default     = []
}
variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "A list of resource ids for subnets."
  default     = []
}
variable "traffic_bypass" {
  type        = list(string)
  description = "Specifies which traffic can bypass the network rules. Possible values are AzureServices and None"
  default     = ["None"]
}
variable "private_endpoints" {
  type = list(object({
    sub_resource_name   = string
    dns_zone_group      = string
    private_dns_zone_id = string
  }))
  description = "Keyvault private endpoint configuration"
  default     = []
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
  default     = null
}
