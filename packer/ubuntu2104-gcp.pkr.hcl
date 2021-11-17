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
  default = "caravan-ubuntu-image"
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
  default = null
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

locals {
  image_family               = "${var.image_name}-os"
  image_family_enterprise    = "${var.image_name}-ent"
  full_image_name            = "${local.image_family}-{{timestamp}}"
  full_image_name_enterprise = "${local.image_family_enterprise}-{{timestamp}}"
  ssh_username               = "ubuntu"
  image_labels               = merge({ for k, v in yamldecode(file(var.apps_bin_versions)) : k => replace(v, ".", "_") if length(regexall(".*_version", k)) > 0 }, { for k, v in yamldecode(file(var.hc_bin_versions)) : k => replace(v, ".", "_") if length(regexall(".*_version", k)) > 0 })
  tags                       = var.install_nomad ? local.image_labels : merge(local.image_labels, { "nomad_version" : "none" })
}

source "googlecompute" "ubuntu" {
  project_id   = var.project_id
  account_file = var.account_file
  region       = var.region
  zone         = var.zone
  network      = var.network_name
  subnetwork   = var.subnetwork_name
  machine_type = var.machine_type

  source_image_family = "ubuntu-2104"

  disk_size = 20
  disk_type = "pd-ssd"

  ssh_username = local.ssh_username

  tags         = ["ssh-allowed-node", "packer-builder"]
  image_labels = local.tags
}

build {
  name = "caravan"

  source "source.googlecompute.ubuntu" {
    name              = "opensource"
    instance_name     = local.full_image_name
    image_name        = local.full_image_name
    image_family      = local.image_family
    image_description = "Caravan Ubuntu 21.04"
  }

  source "source.googlecompute.ubuntu" {
    name              = "enterprise"
    instance_name     = local.full_image_name_enterprise
    image_name        = local.full_image_name_enterprise
    image_family      = local.image_family_enterprise
    image_description = "Caravan Ubuntu 21.04 - Enterprise"
  }

  provisioner "shell" {
    inline = [
      "curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py",
      "python get-pip.py",
      "python -m pip install --user ansible==4.8.0"
    ]
  }

  provisioner "ansible-local" {
    playbook_file    = "../ansible/centos.yml"
    playbook_dir     = "../ansible/"
    galaxy_file      = "../ansible/requirements.yml"
    inventory_groups = ["gcp"]
    command          = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/centos/.local/bin/ansible-playbook"
    galaxy_command   = "/home/centos/.local/bin/ansible-galaxy"
    override = {
      enterprise = {
        inventory_groups = ["gcp", "enterprise"]
      }
    }
    extra_arguments = [
      "--extra-vars", "install_nomad=${var.install_nomad}"
    ]
  }

  provisioner "shell" {
    script = "scripts/ubuntu-cleanup.sh"
  }

  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }
}
