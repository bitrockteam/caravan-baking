variable "build_machine_type" {
  type    = string
  default = "n1-standard-1"
}
variable "build_region" {
  type    = string
  default = "us-central1"
}
variable "build_zone" {
  type    = string
  default = "us-central1-a"
}
variable "build_on_google" {
  type    = bool
  default = false
}
variable "google_project_id" {
  type    = string
  default = ""
}
variable "google_account_file" {
  type    = string
  default = null
}
variable "google_network_name" {
  type    = string
  default = "default"
}
variable "google_subnetwork_name" {
  type    = string
  default = "default"
}
variable "google_firewall_name" {
  type    = string
  default = "default"
}
variable "build_on_aws" {
  type    = bool
  default = false
}
variable "aws_access_key" {
  type      = string
  sensitive = true
  default   = ""
}
variable "aws_secret_key" {
  type      = string
  sensitive = true
  default   = ""
}
variable "aws_region" {
  type    = string
  default = "eu-central-1"
}
variable "aws_instance_type" {
  type    = string
  default = "t3.small"
}
variable "build_on_oci" {
  type    = bool
  default = false
}
variable "oci_profile" {
  type    = string
  default = "POCIMAGE"
}
variable "oci_subnet_ocid" {
  type    = string
  default = null
}
variable "oci_compartment_ocid" {
  type    = string
  default = null
}
variable "oci_artifacts_bucket" {
  type    = string
  default = "artifacts"
}
variable "build_on_azure" {
  type    = bool
  default = false
}
variable "azure_subscription_id" {
  type    = string
  default = null
}
variable "azure_client_id" {
  type    = string
  default = null
}
variable "azure_client_secret" {
  type      = string
  sensitive = true
  default   = null
}
variable "azure_target_resource_group" {
  type    = string
  default = "caravan-images"
}

variable "base_image_ocid" {
  type    = string
  default = null
}
variable "preload_artifacts" {
  type    = string
  default = null
}
variable "preload_artifacts_base_url" {
  type    = string
  default = null
}
variable "skip_packer_build" {
  type    = bool
  default = false
}
variable "bastion_host" {
  type    = string
  default = null
}
variable "bastion_username" {
  type    = string
  default = null
}
variable "bastion_private_key_file" {
  type    = string
  default = null
}

variable "proxy" {
  type    = string
  default = null
}
variable "dummy_ip" {
  type    = string
  default = "192.168.0.1"
}
variable "nameservers" {
  type    = list(string)
  default = ["169.254.169.254"]
}
variable "builds" {
  type        = list(string)
  default     = ["caravan.*.enterprise", "caravan.*.opensource"]
  description = "Which packer build artefacts to produce"
}
variable "apps_bin_versions" {
  type    = string
  default = "../ansible/roles/hc_stack_apps/defaults/main.yml"
}

variable "hc_bin_versions" {
  type    = string
  default = "../ansible/roles/hc_stack_install/defaults/main.yml"
}

variable "install_nomad" {
  type    = bool
  default = true
}

variable "linux_os_family" {
  type    = string
  default = "redhat"
}

variable "linux_os_version" {
  type    = string
  default = "7"
}

variable "linux_os" {
  type    = string
  default = "centos"
}

variable "ssh_username" {
  type    = string
  default = "centos"
}
