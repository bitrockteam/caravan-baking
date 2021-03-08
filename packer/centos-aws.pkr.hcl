variable "access_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "secret_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "image_name" {
  type    = string
  default = "caravan-centos-image"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

locals {
  full_image_name            = "${var.image_name}-{{timestamp}}"
  full_image_name_enterprise = "${var.image_name}-ent-{{timestamp}}"
}

source "amazon-ebs" "centos_7" {
  access_key    = var.access_key
  secret_key    = var.secret_key
  region        = var.region
  instance_type = var.instance_type

  ami_regions = [var.region]

  ssh_username = "centos"
  tags = {
    Owner = "packer-builder-caravan"
  }

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      product-code        = "cvugziknvmxgqna9noibqnnsy"
    }
    owners      = ["aws-marketplace"]
    most_recent = true
  }

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 20
  }
}

build {
  name = "caravan"

  source "source.amazon-ebs.centos_7" {
    name = "opensource"

    ami_name        = local.full_image_name
    ami_description = "Caravan Centos7"
  }

  source "source.amazon-ebs.centos_7" {
    name = "enterprise"

    ami_name        = local.full_image_name_enterprise
    ami_description = "Caravan Centos7 - Enterprise"
  }

  provisioner "ansible" {
    playbook_file       = "../ansible/centos-aws.yml"
    inventory_directory = "../ansible"
    groups              = ["centos_aws"]
    ansible_env_vars = [
      "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES"
    ]
    override = {
      enterprise = {
        groups = ["centos_aws", "enterprise"]
      }
    }
  }

  provisioner "shell" {
    script = "scripts/centos-cleanup.sh"
  }

  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }

}
