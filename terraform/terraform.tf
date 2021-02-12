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
    command     = "packer build -force packer-centos-aws.json"
    environment = {
      AWS_ACCESS_KEY    = var.aws_access_key
      AWS_SECRET_KEY    = var.aws_secret_key
      AWS_REGION        = var.aws_region
      AWS_IMAGE_NAME    = var.build_image_name
      AWS_INSTANCE_TYPE = var.aws_instance_type
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
    command     = "packer build -force packer-centos-azure.json"
    environment = {
      AZURE_SUBSCRIPTION_ID       = var.azure_subscription_id
      AZURE_CLIENT_ID             = var.azure_client_id
      AZURE_CLIENT_SECRET         = var.azure_client_secret
      AZURE_IMAGE_NAME            = var.build_image_name
      AZURE_TARGET_RESOURCE_GROUP = var.azure_target_resource_group
      // select accordingly to the hypervisor gen
      AZURE_VM_SIZE   = "Standard_B2s"
      AZURE_IMAGE_SKU = "7_9-gen2"
    }
  }
}

