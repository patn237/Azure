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
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.nsg_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_to_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | n/a | yes |
| <a name="input_delegation_actions"></a> [delegation\_actions](#input\_delegation\_actions) | A list of Actions which should be delegated. This list is specific to the service to delegate to. | `list(string)` | `null` | no |
| <a name="input_delegation_name"></a> [delegation\_name](#input\_delegation\_name) | Subnet Delegation Name | `string` | `null` | no |
| <a name="input_enable_subnet_delegation"></a> [enable\_subnet\_delegation](#input\_enable\_subnet\_delegation) | Toggle to Enable/Disable Subnet Delegation | `bool` | `false` | no |
| <a name="input_enable_subnet_nsg"></a> [enable\_subnet\_nsg](#input\_enable\_subnet\_nsg) | Toggle to create or skip nsg creation | `bool` | n/a | yes |
| <a name="input_nsg_rules"></a> [nsg\_rules](#input\_nsg\_rules) | n/a | <pre>list(object({<br>    name                         = string<br>    priority                     = number<br>    direction                    = string<br>    access                       = string<br>    protocol                     = string<br>    source_port_ranges           = string<br>    destination_port_range       = string<br>    destination_port_ranges      = string<br>    source_address_prefix        = string<br>    source_address_prefixes      = string<br>    destination_address_prefix   = string<br>    destination_address_prefixes = string<br>  }))</pre> | `[]` | no |
| <a name="input_override_naming_convention"></a> [override\_naming\_convention](#input\_override\_naming\_convention) | Toggle used to override the subnet naming convention | `bool` | n/a | yes |
| <a name="input_private_endpoint_network_policies"></a> [private\_endpoint\_network\_policies](#input\_private\_endpoint\_network\_policies) | Enable or Disable network policies for the private endpoint on the subnet. Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. | `string` | `"NetworkSecurityGroupEnabled"` | no |
| <a name="input_rsg_name"></a> [rsg\_name](#input\_rsg\_name) | The name of the resource group in which the resources will be created | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The list of Service endpoints to associate with the subnet. | `list(string)` | `null` | no |
| <a name="input_services_to_delegate"></a> [services\_to\_delegate](#input\_services\_to\_delegate) | A name for this delegation. | `string` | `null` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the subnet | `string` | n/a | yes |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | IP CIDR for the new subnet | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be appended to the resource | `map(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the vnet where the subnet will reside | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | n/a |
| <a name="output_nsg_rule_id"></a> [nsg\_rule\_id](#output\_nsg\_rule\_id) | n/a |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | n/a |
<!-- END_TF_DOCS -->