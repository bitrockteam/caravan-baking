variable "machine_type" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "zone" {
  type    = string
  default = ""
}

variable "image_name" {
  type    = string
  default = "caravan-centos-image"
}

variable "project_id" {
  type    = string
  default = ""
}

variable "network_name" {
  type    = string
  default = ""
}

variable "account_file" {
  type    = string
  default = ""
}

variable "network_project_id" {
  type    = string
  default = "default"
}

variable "subnetwork_name" {
  type    = string
  default = ""
}

variable "firewall_name" {
  type    = string
  default = ""
}

locals {
  image_family               = var.image_name
  image_family_enterprise    = "${var.image_name}-ent"
  full_image_name            = "${local.image_family}-{{timestamp}}"
  full_image_name_enterprise = "${local.image_family_enterprise}-{{timestamp}}"
}

source "googlecompute" "centos_7" {
  project_id   = var.project_id
  account_file = var.account_file
  region       = var.region
  zone         = var.zone
  network      = var.network_name
  subnetwork   = var.subnetwork_name
  machine_type = var.machine_type

  source_image_family = "centos-7"

  disk_size = 20
  disk_type = "pd-ssd"

  ssh_username = "centos"

  tags = ["ssh-allowed-node", "packer-builder"]
}

build {
  name = "caravan"

  source "source.googlecompute.centos_7" {
    name              = "opensource"
    instance_name     = local.full_image_name
    image_family      = local.image_family
    image_description = "Caravan Centos7"
  }

  source "source.googlecompute.centos_7" {
    name              = "enterprise"
    instance_name     = local.full_image_name_enterprise
    image_family      = local.image_family_enterprise
    image_description = "Caravan Centos7 - Enterprise"
  }

  provisioner "ansible" {
    playbook_file       = "../ansible/centos-gcp.yml"
    inventory_directory = "../ansible"
    groups              = ["centos_gcp"]
    ansible_env_vars = [
      "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES"
    ]
    override = {
      enterprise = {
        groups = ["centos_gcp", "enterprise"]
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