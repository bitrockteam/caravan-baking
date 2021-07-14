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

variable "apps_bin_versions" {
  type    = string
  default = "../ansible/roles/hc_stack_apps/defaults/main.yml"
}

variable "hc_bin_versions" {
  type    = string
  default = "../ansible/roles/hc_stack_install/defaults/main.yml"
}

locals {
  image_family               = "${var.image_name}-os"
  image_family_enterprise    = "${var.image_name}-ent"
  full_image_name            = "${local.image_family}-{{timestamp}}"
  full_image_name_enterprise = "${local.image_family_enterprise}-{{timestamp}}"
  ssh_username               = "centos"
  image_labels               = merge({ for k, v in yamldecode(file(var.apps_bin_versions)) : k => replace(v, ".", "_") if length(regexall(".*_version", k)) > 0 }, { for k, v in yamldecode(file(var.hc_bin_versions)) : k => replace(v, ".", "_") if length(regexall(".*_version", k)) > 0 })
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

  ssh_username = local.ssh_username

  tags         = ["ssh-allowed-node", "packer-builder"]
  image_labels = local.image_labels
}

build {
  name = "caravan"

  source "source.googlecompute.centos_7" {
    name              = "opensource"
    instance_name     = local.full_image_name
    image_name        = local.full_image_name
    image_family      = local.image_family
    image_description = "Caravan Centos7"
  }

  source "source.googlecompute.centos_7" {
    name              = "enterprise"
    instance_name     = local.full_image_name_enterprise
    image_name        = local.full_image_name_enterprise
    image_family      = local.image_family_enterprise
    image_description = "Caravan Centos7 - Enterprise"
  }

  provisioner "shell" {
    inline = [
      "curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py",
      "python get-pip.py",
      "python -m pip install --user ansible==2.10.7"
    ]
  }

  provisioner "ansible-local" {
    playbook_file       = "../ansible/centos-gcp.yml"
    playbook_dir        = "../ansible/"
    galaxy_file         = "../ansible/requirements.yml"
    inventory_groups    = ["centos_gcp"]
    command             = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/centos/.local/bin/ansible-playbook"
    galaxy_command      = "/home/centos/.local/bin/ansible-galaxy"
    override = {
      enterprise = {
        inventory_groups = ["centos_gcp", "enterprise"]
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
