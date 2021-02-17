

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.1 |

## Providers

| Name | Version |
|------|---------|
| null | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| build\_image\_name | n/a | `string` | n/a | yes |
| aws\_access\_key | n/a | `string` | `""` | no |
| aws\_instance\_type | n/a | `string` | `"t3.small"` | no |
| aws\_region | n/a | `string` | `"eu-central-1"` | no |
| aws\_secret\_key | n/a | `string` | `""` | no |
| azure\_client\_id | n/a | `string` | `null` | no |
| azure\_client\_secret | n/a | `string` | `null` | no |
| azure\_subscription\_id | n/a | `string` | `null` | no |
| azure\_target\_resource\_group | n/a | `string` | `"caravan-images"` | no |
| base\_image\_ocid | n/a | `string` | `null` | no |
| bastion\_host | n/a | `string` | `null` | no |
| bastion\_private\_key\_file | n/a | `string` | `null` | no |
| bastion\_username | n/a | `string` | `null` | no |
| build\_machine\_type | n/a | `string` | `"n1-standard-1"` | no |
| build\_on\_aws | n/a | `bool` | `false` | no |
| build\_on\_azure | n/a | `bool` | `false` | no |
| build\_on\_google | n/a | `bool` | `false` | no |
| build\_on\_oci | n/a | `bool` | `false` | no |
| build\_region | n/a | `string` | `"us-central1"` | no |
| build\_zone | n/a | `string` | `"us-central1-a"` | no |
| dummy\_ip | n/a | `string` | `"192.168.0.1"` | no |
| google\_account\_file | n/a | `string` | `"builder-account.json"` | no |
| google\_firewall\_name | n/a | `string` | `"default"` | no |
| google\_network\_name | n/a | `string` | `null` | no |
| google\_project\_id | n/a | `string` | `""` | no |
| google\_subnetwork\_name | n/a | `string` | `null` | no |
| nameservers | n/a | `list(string)` | <pre>[<br>  "169.254.169.254"<br>]</pre> | no |
| oci\_artifacts\_bucket | n/a | `string` | `"artifacts"` | no |
| oci\_compartment\_ocid | n/a | `string` | `null` | no |
| oci\_profile | n/a | `string` | `"POCIMAGE"` | no |
| oci\_subnet\_ocid | n/a | `string` | `null` | no |
| pkg\_list | n/a | `list(string)` | <pre>[<br>  "wget",<br>  "unzip",<br>  "jq",<br>  "dnsmasq",<br>  "openjdk-8-jdk",<br>  "java-1.8.0-openjdk",<br>  "bind-utils",<br>  "tcpdump"<br>]</pre> | no |
| preload\_artifacts | n/a | `string` | `null` | no |
| preload\_artifacts\_base\_url | n/a | `string` | `null` | no |
| proxy | n/a | `string` | `null` | no |
| skip\_packer\_build | n/a | `bool` | `false` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

