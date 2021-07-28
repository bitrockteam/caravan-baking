

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.ansible_galaxy_deps](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mac_gnu_tar](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.run_packer_aws](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.run_packer_azure](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.run_packer_google](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_image_name"></a> [build\_image\_name](#input\_build\_image\_name) | n/a | `string` | n/a | yes |
| <a name="input_apps_bin_versions"></a> [apps\_bin\_versions](#input\_apps\_bin\_versions) | n/a | `string` | `"../ansible/roles/hc_stack_apps/defaults/main.yml"` | no |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | `""` | no |
| <a name="input_aws_instance_type"></a> [aws\_instance\_type](#input\_aws\_instance\_type) | n/a | `string` | `"t3.small"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | n/a | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | n/a | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | n/a | `string` | `null` | no |
| <a name="input_azure_target_resource_group"></a> [azure\_target\_resource\_group](#input\_azure\_target\_resource\_group) | n/a | `string` | `"caravan-images"` | no |
| <a name="input_base_image_ocid"></a> [base\_image\_ocid](#input\_base\_image\_ocid) | n/a | `string` | `null` | no |
| <a name="input_bastion_host"></a> [bastion\_host](#input\_bastion\_host) | n/a | `string` | `null` | no |
| <a name="input_bastion_private_key_file"></a> [bastion\_private\_key\_file](#input\_bastion\_private\_key\_file) | n/a | `string` | `null` | no |
| <a name="input_bastion_username"></a> [bastion\_username](#input\_bastion\_username) | n/a | `string` | `null` | no |
| <a name="input_build_machine_type"></a> [build\_machine\_type](#input\_build\_machine\_type) | n/a | `string` | `"n1-standard-1"` | no |
| <a name="input_build_on_aws"></a> [build\_on\_aws](#input\_build\_on\_aws) | n/a | `bool` | `false` | no |
| <a name="input_build_on_azure"></a> [build\_on\_azure](#input\_build\_on\_azure) | n/a | `bool` | `false` | no |
| <a name="input_build_on_google"></a> [build\_on\_google](#input\_build\_on\_google) | n/a | `bool` | `false` | no |
| <a name="input_build_on_oci"></a> [build\_on\_oci](#input\_build\_on\_oci) | n/a | `bool` | `false` | no |
| <a name="input_build_region"></a> [build\_region](#input\_build\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_build_zone"></a> [build\_zone](#input\_build\_zone) | n/a | `string` | `"us-central1-a"` | no |
| <a name="input_builds"></a> [builds](#input\_builds) | Which packer build artefacts to produce | `list(string)` | <pre>[<br>  "caravan.*.enterprise",<br>  "caravan.*.opensource"<br>]</pre> | no |
| <a name="input_dummy_ip"></a> [dummy\_ip](#input\_dummy\_ip) | n/a | `string` | `"192.168.0.1"` | no |
| <a name="input_google_account_file"></a> [google\_account\_file](#input\_google\_account\_file) | n/a | `string` | `"builder-account.json"` | no |
| <a name="input_google_firewall_name"></a> [google\_firewall\_name](#input\_google\_firewall\_name) | n/a | `string` | `"default"` | no |
| <a name="input_google_network_name"></a> [google\_network\_name](#input\_google\_network\_name) | n/a | `string` | `null` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | n/a | `string` | `""` | no |
| <a name="input_google_subnetwork_name"></a> [google\_subnetwork\_name](#input\_google\_subnetwork\_name) | n/a | `string` | `null` | no |
| <a name="input_hc_bin_versions"></a> [hc\_bin\_versions](#input\_hc\_bin\_versions) | n/a | `string` | `"../ansible/roles/hc_stack_install/defaults/main.yml"` | no |
| <a name="input_install_nomad"></a> [install\_nomad](#input\_install\_nomad) | n/a | `bool` | `true` | no |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | n/a | `list(string)` | <pre>[<br>  "169.254.169.254"<br>]</pre> | no |
| <a name="input_oci_artifacts_bucket"></a> [oci\_artifacts\_bucket](#input\_oci\_artifacts\_bucket) | n/a | `string` | `"artifacts"` | no |
| <a name="input_oci_compartment_ocid"></a> [oci\_compartment\_ocid](#input\_oci\_compartment\_ocid) | n/a | `string` | `null` | no |
| <a name="input_oci_profile"></a> [oci\_profile](#input\_oci\_profile) | n/a | `string` | `"POCIMAGE"` | no |
| <a name="input_oci_subnet_ocid"></a> [oci\_subnet\_ocid](#input\_oci\_subnet\_ocid) | n/a | `string` | `null` | no |
| <a name="input_pkg_list"></a> [pkg\_list](#input\_pkg\_list) | n/a | `list(string)` | <pre>[<br>  "wget",<br>  "unzip",<br>  "jq",<br>  "dnsmasq",<br>  "openjdk-8-jdk",<br>  "java-1.8.0-openjdk",<br>  "bind-utils",<br>  "tcpdump"<br>]</pre> | no |
| <a name="input_preload_artifacts"></a> [preload\_artifacts](#input\_preload\_artifacts) | n/a | `string` | `null` | no |
| <a name="input_preload_artifacts_base_url"></a> [preload\_artifacts\_base\_url](#input\_preload\_artifacts\_base\_url) | n/a | `string` | `null` | no |
| <a name="input_proxy"></a> [proxy](#input\_proxy) | n/a | `string` | `null` | no |
| <a name="input_skip_packer_build"></a> [skip\_packer\_build](#input\_skip\_packer\_build) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_installed_versions"></a> [installed\_versions](#output\_installed\_versions) | List of each component and version. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

