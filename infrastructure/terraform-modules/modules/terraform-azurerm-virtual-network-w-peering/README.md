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
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.peer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | n/a | yes |
| <a name="input_rsg_name"></a> [rsg\_name](#input\_rsg\_name) | The name of the resource group in which the resources will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be appended to the resource group on creation | `map(string)` | `null` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space that is used the virtual network. You can supply more than one address space. | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the virtual network. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_vnet_peerings"></a> [vnet\_peerings](#input\_vnet\_peerings) | A List of objects used to configure Virtual Network Peerings against the deployed Virtual Network | <pre>list(object({<br>    remote_vnet_name        = string<br>    remote_vnet_id          = string<br>    allow_gateway_transit   = bool<br>    allow_forwarded_traffic = bool<br>    use_remote_gateways     = bool<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of the deployed virtual network resource |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of the deployed virtual network resource |
<!-- END_TF_DOCS -->