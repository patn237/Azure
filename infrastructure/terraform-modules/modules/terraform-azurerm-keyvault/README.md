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
| [azurerm_key_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_private_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | n/a | yes |
| <a name="input_azurerm_tenant_id"></a> [azurerm\_tenant\_id](#input\_azurerm\_tenant\_id) | The Tenant ID where this Keyvault should reside | `string` | n/a | yes |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | The Default Action to use when no rules match | `string` | `"Allow"` | no |
| <a name="input_enable_network_acls"></a> [enable\_network\_acls](#input\_enable\_network\_acls) | Toggle Flag to enable/disable network access lists | `bool` | `false` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_keyvault_sku"></a> [keyvault\_sku](#input\_keyvault\_sku) | The Name of the SKU used for this Key Vault. Possible values are 'standard' and 'premium'. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the Key Vault. | `string` | n/a | yes |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. | `string` | `null` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Keyvault private endpoint configuration | <pre>list(object({<br>    sub_resource_name   = string<br>    dns_zone_group      = string<br>    private_dns_zone_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_public_ips"></a> [public\_ips](#input\_public\_ips) | List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. | `list(string)` | `[]` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Purge Protection for this Key Vault | `string` | `false` | no |
| <a name="input_rsg_name"></a> [rsg\_name](#input\_rsg\_name) | The name of the Resource Group for this deployment | `string` | n/a | yes |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be appended to the resource | `map(string)` | n/a | yes |
| <a name="input_traffic_bypass"></a> [traffic\_bypass](#input\_traffic\_bypass) | Specifies which traffic can bypass the network rules. Possible values are AzureServices and None | `string` | `"None"` | no |
| <a name="input_virtual_network_subnet_ids"></a> [virtual\_network\_subnet\_ids](#input\_virtual\_network\_subnet\_ids) | One or more Subnet IDs which should be able to access this Key Vault. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->