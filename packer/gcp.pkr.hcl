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

variable "image_prefix" {
  type    = string
  default = "caravan"
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

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "linux_os" {
  type    = string
  default = "ubuntu"
}

variable "linux_os_family" {
  type    = string
  default = "debian"
}

variable "linux_os_version" {
  type    = string
  default = "2104"
}

# add LTS suffix ubuntu GCP images
variable "ubuntu_lts_map" {
  type = map(string)
  default = {
    "1604" = "1604-lts"
    "1804" = "1804-lts"
    "2004" = "2004-lts"
    "2104" = "2104"
  }
}

locals {
  linux_os_version_gcp       = lookup(var.ubuntu_lts_map, var.linux_os_version, var.linux_os_version)
  linux_distro               = "${var.linux_os}-${local.linux_os_version_gcp}"
  image_family               = "${var.image_prefix}-os-${local.linux_distro}"
  image_family_enterprise    = "${var.image_prefix}-ent-${local.linux_distro}"
  full_image_name            = "${local.image_family}-{{timestamp}}"
  full_image_name_enterprise = "${local.image_family_enterprise}-{{timestamp}}"
  ssh_username               = var.ssh_username
  image_labels               = merge({ for k, v in yamldecode(file(var.apps_bin_versions)) : k => replace(v, ".", "_") if length(regexall(".*_version", k)) > 0 }, { for k, v in yamldecode(file(var.hc_bin_versions)) : k => replace(v, ".", "_") if length(regexall(".*_version", k)) > 0 })
  tags                       = var.install_nomad ? local.image_labels : merge(local.image_labels, { "nomad_version" : "none" })
}

source "googlecompute" "caravan" {
  project_id   = var.project_id
  account_file = var.account_file
  region       = var.region
  zone         = var.zone
  network      = var.network_name
  subnetwork   = var.subnetwork_name
  machine_type = var.machine_type

  source_image_family = local.linux_distro

  disk_size = 20
  disk_type = "pd-ssd"

  ssh_username = local.ssh_username

  tags         = ["ssh-allowed-node", "packer-builder"]
  image_labels = local.tags
}

build {
  name = "caravan"

  source "source.googlecompute.caravan" {
    name              = "opensource"
    instance_name     = local.full_image_name
    image_name        = local.full_image_name
    image_family      = local.image_family
    image_description = "Caravan ${local.linux_distro}"
  }

  source "source.googlecompute.caravan" {
    name              = "enterprise"
    instance_name     = local.full_image_name_enterprise
    image_name        = local.full_image_name_enterprise
    image_family      = local.image_family_enterprise
    image_description = "Caravan ${local.linux_distro} - Enterprise"
  }

  provisioner "shell" {
    environment_vars = [
      "ANSIBLE_VERSION=4.8.0",
    ]
    script = "scripts/${var.linux_os_family}-bootstrap-ansible.sh"
  }

  provisioner "ansible-local" {
    playbook_file    = "../ansible/caravan.yml"
    playbook_dir     = "../ansible/"
    galaxy_file      = "../ansible/requirements.yml"
    inventory_groups = ["gcp"]
    command          = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/${var.ssh_username}/.local/bin/ansible-playbook"
    galaxy_command   = "/home/${var.ssh_username}/.local/bin/ansible-galaxy"
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
    script = "scripts/${var.linux_os_family}-cleanup.sh"
  }

  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }
}
