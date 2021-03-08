terraform {
  required_version = "~> 0.13.1"
}

resource "null_resource" "run_packer_google" {
  count = (var.build_on_google && ! var.skip_packer_build) ? 1 : 0
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/centos-gcp.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-groupvars-gcp" : filemd5("${path.module}/../ansible/group_vars/centos_gcp")
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../packer"
    command     = "packer build -force packer-centos-gcp.json"
    environment = {
      GOOGLE_IMAGE_NAME      = var.build_image_name
      GOOGLE_MACHINE_TYPE    = var.build_machine_type
      GOOGLE_REGION          = var.build_region
      GOOGLE_ZONE            = var.build_zone
      GOOGLE_ACCOUNT_FILE    = var.google_account_file
      GOOGLE_PROJECT_ID      = var.google_project_id
      GOOGLE_NETWORK_NAME    = var.google_network_name
      GOOGLE_SUBNETWORK_NAME = var.google_subnetwork_name
      GOOGLE_FIREWALL_NAME   = var.google_firewall_name
    }
  }
}

resource "null_resource" "run_packer_aws" {
  count = (var.build_on_aws && ! var.skip_packer_build) ? 1 : 0
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/centos-aws.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-groupvars-aws" : filemd5("${path.module}/../ansible/group_vars/centos_aws")
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
  count = (var.build_on_azure && ! var.skip_packer_build) ? 1 : 0
  triggers = {
    "changes-in-playbook" : filemd5("${path.module}/../ansible/centos-azure.yml")
    "changes-in-groupvars-all" : filemd5("${path.module}/../ansible/group_vars/all")
    "changes-in-groupvars-azure" : filemd5("${path.module}/../ansible/group_vars/centos_azure")
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

