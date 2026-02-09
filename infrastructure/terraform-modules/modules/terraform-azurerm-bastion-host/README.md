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
| [azurerm_bastion_host.bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_public_ip.bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocation_method"></a> [allocation\_method](#input\_allocation\_method) | (Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created. | `string` | `"Static"` | no |
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | n/a | yes |
| <a name="input_bh_copy_paste"></a> [bh\_copy\_paste](#input\_bh\_copy\_paste) | (Optional) Is Copy/Paste feature enabled for the Bastion Host | `bool` | n/a | yes |
| <a name="input_bh_file_copy"></a> [bh\_file\_copy](#input\_bh\_file\_copy) | (Optional) Is File Copy feature enabled for the Bastion Host | `bool` | n/a | yes |
| <a name="input_bh_name"></a> [bh\_name](#input\_bh\_name) | (Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_bh_public_ip_name"></a> [bh\_public\_ip\_name](#input\_bh\_public\_ip\_name) | (Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created. | `string` | n/a | yes |
| <a name="input_bh_sku"></a> [bh\_sku](#input\_bh\_sku) | (Optional) The SKU of the Bastion Host. Accepted values are Basic and Standard. | `string` | n/a | yes |
| <a name="input_bh_subnet_subnet_id"></a> [bh\_subnet\_subnet\_id](#input\_bh\_subnet\_subnet\_id) | (Required) Reference to a subnet in which this Bastion Host has been created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_bh_tunneling"></a> [bh\_tunneling](#input\_bh\_tunneling) | (Optional) Is Tunneling feature enabled for the Bastion Host | `bool` | n/a | yes |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | (Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic. Changing this forces a new resource to be created. | `string` | `"Standard"` | no |
| <a name="input_rsg_name"></a> [rsg\_name](#input\_rsg\_name) | The name of the resource group in which the resources will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be appended to the resource | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bh_id"></a> [bh\_id](#output\_bh\_id) | n/a |
| <a name="output_bh_name"></a> [bh\_name](#output\_bh\_name) | n/a |
| <a name="output_bh_public_ip"></a> [bh\_public\_ip](#output\_bh\_public\_ip) | n/a |
| <a name="output_bh_public_ip_name"></a> [bh\_public\_ip\_name](#output\_bh\_public\_ip\_name) | n/a |
<!-- END_TF_DOCS -->