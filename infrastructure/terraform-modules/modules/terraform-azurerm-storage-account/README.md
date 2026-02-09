<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.containers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_share.share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public. | `bool` | `false` | no |
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | n/a | yes |
| <a name="input_blob_containers"></a> [blob\_containers](#input\_blob\_containers) | List of storage account containers to create within the storage account | `list(string)` | `[]` | no |
| <a name="input_blob_delete_retention_days"></a> [blob\_delete\_retention\_days](#input\_blob\_delete\_retention\_days) | Specifies the number of days that the blobs should be retained | `number` | `7` | no |
| <a name="input_change_feed_retention_days"></a> [change\_feed\_retention\_days](#input\_change\_feed\_retention\_days) | The duration of change feed events retention in days. The possible values are between 1 and 146000 days (400 years). Not setting this value will indicate infinite change feed retention. | `number` | `null` | no |
| <a name="input_configure_blob_properties"></a> [configure\_blob\_properties](#input\_configure\_blob\_properties) | Toggle to enable blob properties for the azure storage account | `bool` | `false` | no |
| <a name="input_container_delete_retention_days"></a> [container\_delete\_retention\_days](#input\_container\_delete\_retention\_days) | Specifies the number of days that the containers should be retained | `number` | `7` | no |
| <a name="input_default_network_rule_action"></a> [default\_network\_rule\_action](#input\_default\_network\_rule\_action) | Default Network Rule Action | `string` | `"Deny"` | no |
| <a name="input_enable_access_with_shared_access_key"></a> [enable\_access\_with\_shared\_access\_key](#input\_enable\_access\_with\_shared\_access\_key) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key | `bool` | `true` | no |
| <a name="input_enable_blob_versioning"></a> [enable\_blob\_versioning](#input\_enable\_blob\_versioning) | Is blob versioning enabled? | `bool` | `false` | no |
| <a name="input_enable_change_feed"></a> [enable\_change\_feed](#input\_enable\_change\_feed) | Is change feed enabled? | `bool` | `false` | no |
| <a name="input_enable_file_share"></a> [enable\_file\_share](#input\_enable\_file\_share) | Toggle to enable/disable file share on this storage account | `bool` | `false` | no |
| <a name="input_enable_network_rules"></a> [enable\_network\_rules](#input\_enable\_network\_rules) | Toggle to enable/disable firewall rules for this storage account | `bool` | `false` | no |
| <a name="input_file_shares"></a> [file\_shares](#input\_file\_shares) | List of objects used to create file shares within the storage account | <pre>list(object({<br>    file_share_name     = string<br>    file_share_quota_gb = number<br>  }))</pre> | `[]` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | n/a | yes |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. | `string` | `null` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Keyvault private endpoint configuration | <pre>list(object({<br>    sub_resource_name   = string<br>    dns_zone_group      = string<br>    private_dns_zone_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_public_ips"></a> [public\_ips](#input\_public\_ips) | List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. | `list(string)` | `[]` | no |
| <a name="input_replication_type"></a> [replication\_type](#input\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. | `string` | n/a | yes |
| <a name="input_rsg_name"></a> [rsg\_name](#input\_rsg\_name) | The name of the resource group in which the resources will be created | `string` | n/a | yes |
| <a name="input_stor_acc_name"></a> [stor\_acc\_name](#input\_stor\_acc\_name) | The name used for the Storage Account. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be appended to the resource group on creation | `map(string)` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | Defines the Tier to use for this storage account. Valid options are Standard and Premium. | `string` | n/a | yes |
| <a name="input_traffic_bypass"></a> [traffic\_bypass](#input\_traffic\_bypass) | Specifies which traffic can bypass the network rules. Possible values are AzureServices and None | `list(string)` | <pre>[<br>  "None"<br>]</pre> | no |
| <a name="input_virtual_network_subnet_ids"></a> [virtual\_network\_subnet\_ids](#input\_virtual\_network\_subnet\_ids) | A list of resource ids for subnets. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stor_acc_id"></a> [stor\_acc\_id](#output\_stor\_acc\_id) | n/a |
| <a name="output_stor_acc_name"></a> [stor\_acc\_name](#output\_stor\_acc\_name) | n/a |
| <a name="output_stor_pri_access_key"></a> [stor\_pri\_access\_key](#output\_stor\_pri\_access\_key) | n/a |
| <a name="output_stor_pri_blob_endpoint"></a> [stor\_pri\_blob\_endpoint](#output\_stor\_pri\_blob\_endpoint) | n/a |
| <a name="output_stor_pri_hostname"></a> [stor\_pri\_hostname](#output\_stor\_pri\_hostname) | n/a |
| <a name="output_stor_sec_access_key"></a> [stor\_sec\_access\_key](#output\_stor\_sec\_access\_key) | n/a |
<!-- END_TF_DOCS -->