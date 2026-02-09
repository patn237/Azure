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
| [azurerm_private_dns_a_record.records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_cname_record.records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_resolver.resolver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint) | resource |
| [azurerm_private_dns_zone.zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.link_spokes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_region"></a> [az\_region](#input\_az\_region) | The location where resources will be created | `string` | `"WestUS"` | no |
| <a name="input_deploy_dns_resolver"></a> [deploy\_dns\_resolver](#input\_deploy\_dns\_resolver) | Toggle used to deploy the dns resolver resource | `bool` | `false` | no |
| <a name="input_dns_resolver_name"></a> [dns\_resolver\_name](#input\_dns\_resolver\_name) | Name of the DNS Resolver Resource to be deployed | `string` | `null` | no |
| <a name="input_dns_resolver_subnet_id"></a> [dns\_resolver\_subnet\_id](#input\_dns\_resolver\_subnet\_id) | Subnet ID where the DNS resolver IPs will reside | `string` | `null` | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | Specifies a list of private dns zones to create | <pre>list(object({<br>    dns_zone              = string<br>    dns_auto_registration = bool<br>    dns_records = list(object({<br>      name         = string<br>      ttl          = number<br>      ip_addresses = optional(list(string))<br>      cname_record = optional(string)<br>      type         = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_link_hub_vnet_id"></a> [link\_hub\_vnet\_id](#input\_link\_hub\_vnet\_id) | The Hub VNET ID to be linked with the private zone | `string` | n/a | yes |
| <a name="input_list_of_inbound_dns_resolver_Static_IP_Endpoints"></a> [list\_of\_inbound\_dns\_resolver\_Static\_IP\_Endpoints](#input\_list\_of\_inbound\_dns\_resolver\_Static\_IP\_Endpoints) | List of String of Static IP addresses to assign to the DNS resolver configuration | `list(string)` | `[]` | no |
| <a name="input_list_of_spoke_vnet_ids_for_dns_link"></a> [list\_of\_spoke\_vnet\_ids\_for\_dns\_link](#input\_list\_of\_spoke\_vnet\_ids\_for\_dns\_link) | A list of string used to link more spoke virtual networks to the deployed private dns zones | `list(string)` | `[]` | no |
| <a name="input_rsg_name"></a> [rsg\_name](#input\_rsg\_name) | The name of the resource group in which the resources will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be appended to the resource group on creation | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_ids"></a> [zone\_ids](#output\_zone\_ids) | n/a |
<!-- END_TF_DOCS -->