variable "build_image_name" {
  type = string
}
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
  default = "builder-account.json"
}
variable "google_network_name" {
  type    = string
  default = null
}
variable "google_subnetwork_name" {
  type    = string
  default = null
}
variable "google_firewall_name" {
  type    = string
  default = "default"
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

variable "pkg_list" {
  type = list(string)
  default = [
    "wget",
    "unzip",
    "jq",
    "dnsmasq",
    "openjdk-8-jdk",
    "java-1.8.0-openjdk",
    "bind-utils",
    "tcpdump"
  ]
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
