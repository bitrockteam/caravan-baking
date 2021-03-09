variable "source_path" {
  type = string
  default = "bento/centos-7"
}

variable "provider" {
  type = string
  default = "virtualbox"
}

variable "image_name" {
  type = string
  default = "caravan-centos-image"
}

locals {
  full_image_name            = "${var.image_name}-os-{{timestamp}}"
  full_image_name_enterprise = "${var.image_name}-ent-{{timestamp}}"
}

source "vagrant" "centos_7" {
  source_path = var.source_path
  provider = var.provider
  communicator = "ssh"
}

build {
  name = "caravan"

  source "source.vagrant.centos_7" {
    name              = "opensource"
    box_name        = local.full_image_name
  }

  source "source.vagrant.centos_7" {
    name              = "enterprise"
    box_name        = local.full_image_name_enterprise
  }

  provisioner "ansible" {
    playbook_file       = "../ansible/centos.yml"
    inventory_directory = "../ansible"
    groups              = []
    ansible_env_vars = [
      "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES"
    ]
    override = {
      enterprise = {
        groups = ["enterprise"]
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