## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_number_elastic_ips"></a> [number\_elastic\_ips](#input\_number\_elastic\_ips) | The list of EIP allocation IDs for the NAT gateways. | `number` | n/a | yes |
| <a name="input_number_of_natgateways"></a> [number\_of\_natgateways](#input\_number\_of\_natgateways) | The number of nat gateways to create. | `number` | n/a | yes |
| <a name="input_number_of_private_subnets"></a> [number\_of\_private\_subnets](#input\_number\_of\_private\_subnets) | The number of private subnets to create. | `number` | n/a | yes |
| <a name="input_number_of_public_subnets"></a> [number\_of\_public\_subnets](#input\_number\_of\_public\_subnets) | The number of public subnets to create. | `number` | n/a | yes |
| <a name="input_private_subnet_cidr_block"></a> [private\_subnet\_cidr\_block](#input\_private\_subnet\_cidr\_block) | The CIDR block for the private subnet. | `list(string)` | n/a | yes |
| <a name="input_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#input\_public\_subnet\_cidr\_blocks) | The list of CIDR blocks for the public subnets | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region in which the VPC will be created. | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC. | `string` | n/a | yes |

## Outputs

No outputs.
