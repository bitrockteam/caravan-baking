terraform {
  required_version = "~> 0.14"
}

// required by cloudalchemy.node_exporter
resource "null_resource" "mac_gnu_tar" {
  provisioner "local-exec" {
    command     = "if [[ $OSTYPE =~ \"darwin\" ]]; then which gtar || (echo Missing dependency: \"brew install gnu-tar\" && exit 1); fi"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "ansible_galaxy_deps" {
  depends_on = [null_resource.mac_gnu_tar]
  triggers = {
    "changes-in-dependencies" : filemd5("${path.module}/../ansible/requirements.yml")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../ansible"
    command     = "ansible-galaxy install -r requirements.yml"
  }
}

resource "null_resource" "run_packer_google" {
  count = (var.build_on_google && !var.skip_packer_build) ? 1 : 0
  depends_on = [
    null_resource.ansible_galaxy_deps
  ]
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/centos-gcp.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-groupvars-gcp" : filemd5("${path.module}/../ansible/group_vars/centos_gcp")
    "changes-in-packer" : filemd5("${path.module}/../packer/centos-gcp.pkr.hcl")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "packer build -force -only=${join(",", var.builds)} centos-gcp.pkr.hcl"
    environment = {
      PKR_VAR_image_name      = var.build_image_name
      PKR_VAR_machine_type    = var.build_machine_type
      PKR_VAR_region          = var.build_region
      PKR_VAR_zone            = var.build_zone
      PKR_VAR_account_file    = var.google_account_file
      PKR_VAR_project_id      = var.google_project_id
      PKR_VAR_network_name    = var.google_network_name
      PKR_VAR_subnetwork_name = var.google_subnetwork_name
      PKR_VAR_firewall_name   = var.google_firewall_name
    }
  }
}

resource "null_resource" "run_packer_aws" {
  count = (var.build_on_aws && !var.skip_packer_build) ? 1 : 0
  depends_on = [
    null_resource.ansible_galaxy_deps
  ]
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/centos-aws.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-groupvars-aws" : filemd5("${path.module}/../ansible/group_vars/centos_aws")
    "changes-in-packer" : filemd5("${path.module}/../packer/centos-aws.pkr.hcl")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "packer build -force -only=${join(",", var.builds)} centos-aws.pkr.hcl"
    environment = {
      PKR_VAR_access_key    = var.aws_access_key
      PKR_VAR_secret_key    = var.aws_secret_key
      PKR_VAR_region        = var.aws_region
      PKR_VAR_image_name    = var.build_image_name
      PKR_VAR_instance_type = var.aws_instance_type
    }
  }
}

resource "null_resource" "run_packer_azure" {
  count = (var.build_on_azure && !var.skip_packer_build) ? 1 : 0
  depends_on = [
    null_resource.ansible_galaxy_deps
  ]
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/centos-azure.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-groupvars-azure" : filemd5("${path.module}/../ansible/group_vars/centos_azure")
    "changes-in-packer" : filemd5("${path.module}/../packer/centos-azure.pkr.hcl")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "packer build -force -only=${join(",", var.builds)} centos-azure.pkr.hcl"
    environment = {
      PKR_VAR_subscription_id       = var.azure_subscription_id
      PKR_VAR_client_id             = var.azure_client_id
      PKR_VAR_client_secret         = var.azure_client_secret
      PKR_VAR_image_name            = var.build_image_name
      PKR_VAR_target_resource_group = var.azure_target_resource_group
      // select accordingly to the hypervisor gen
      PKR_VAR_vm_size   = "Standard_B2s"
      PKR_VAR_image_sku = "7_9-gen2"
    }
  }
}

