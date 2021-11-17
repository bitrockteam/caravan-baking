terraform {
  required_version = ">= 0.15"
}

locals {
  linux_distro = "${var.linux_family}${var.linux_family_version}"
  common_vars = {
    PKR_VAR_install_nomad        = var.install_nomad
    PKR_VAR_linux_family         = var.linux_family
    PKR_VAR_linux_family_version = var.linux_family_version
    PKR_VAR_linux_distro         = local.linux_distro
    PKR_VAR_image_name           = "caravan-${local.linux_distro}"
    PKR_VAR_ssh_username         = var.ssh_username
  }
  build_image_name = "caravan-${local.linux_distro}"
}

resource "null_resource" "run_packer_google" {
  count = (var.build_on_google && !var.skip_packer_build) ? 1 : 0
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/caravan.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-install-defaults" : filemd5("${path.module}/../ansible/roles/hc_stack_install/defaults/main.yml")
    "changes-in-apps-defaults" : filemd5("${path.module}/../ansible/roles/hc_stack_apps/defaults/main.yml")
    "changes-in-groupvars-gcp" : filemd5("${path.module}/../ansible/group_vars/gcp")
    "changes-in-packer" : filemd5("${path.module}/../packer/gcp.pkr.hcl")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "packer build -force -only=${join(",", var.builds)} gcp.pkr.hcl"
    environment = merge({
      PKR_VAR_machine_type    = var.build_machine_type
      PKR_VAR_region          = var.build_region
      PKR_VAR_zone            = var.build_zone
      PKR_VAR_account_file    = var.google_account_file
      PKR_VAR_project_id      = var.google_project_id
      PKR_VAR_network_name    = var.google_network_name
      PKR_VAR_subnetwork_name = var.google_subnetwork_name
      PKR_VAR_firewall_name   = var.google_firewall_name
    }, local.common_vars)
  }
}

resource "null_resource" "run_packer_aws" {
  count = (var.build_on_aws && !var.skip_packer_build) ? 1 : 0
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/caravan.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-install-defaults" : filemd5("${path.module}/../ansible/roles/hc_stack_install/defaults/main.yml")
    "changes-in-apps-defaults" : filemd5("${path.module}/../ansible/roles/hc_stack_apps/defaults/main.yml")
    "changes-in-groupvars-aws" : filemd5("${path.module}/../ansible/group_vars/aws")
    "changes-in-packer" : filemd5("${path.module}/../packer/aws.pkr.hcl")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "env && packer build -force -only=${join(",", var.builds)} aws.pkr.hcl"
    environment = merge({
      PKR_VAR_access_key    = var.aws_access_key
      PKR_VAR_secret_key    = var.aws_secret_key
      PKR_VAR_region        = var.aws_region
      PKR_VAR_instance_type = var.aws_instance_type
    }, local.common_vars)
  }
}

resource "null_resource" "run_packer_azure" {
  count = (var.build_on_azure && !var.skip_packer_build) ? 1 : 0
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/caravan.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-install-defaults" : filemd5("${path.module}/../ansible/roles/hc_stack_install/defaults/main.yml")
    "changes-in-apps-defaults" : filemd5("${path.module}/../ansible/roles/hc_stack_apps/defaults/main.yml")
    "changes-in-groupvars-azure" : filemd5("${path.module}/../ansible/group_vars/azure")
    "changes-in-packer" : filemd5("${path.module}/../packer/azure.pkr.hcl")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "packer build -force -only=${join(",", var.builds)} azure.pkr.hcl"
    environment = merge({
      PKR_VAR_subscription_id       = var.azure_subscription_id
      PKR_VAR_client_id             = var.azure_client_id
      PKR_VAR_client_secret         = var.azure_client_secret
      PKR_VAR_target_resource_group = var.azure_target_resource_group
      // select accordingly to the hypervisor gen
      PKR_VAR_vm_size   = "Standard_B2s"
      PKR_VAR_image_sku = "7_9-gen2"
    }, local.common_vars)
  }
}

