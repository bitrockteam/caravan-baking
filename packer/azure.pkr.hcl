variable "subscription_id" {
  type    = string
  default = ""
}

variable "client_id" {
  type    = string
  default = ""
}

variable "client_secret" {
  type      = string
  sensitive = true
  default   = ""
}

variable "image_name" {
  type    = string
  default = "caravan-centos-image"
}

variable "target_resource_group" {
  type    = string
  default = ""
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
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

variable "linux_family" {
  type    = string
  default = "centos"
}

variable "linux_family_version" {
  type    = string
  default = "7"
}

variable "image_sku_map" {
  type = map(string)
  default = {
    "centos" = "7_9-gen2"
  }
}

variable "image_publisher_map" {
  type = map(string)
  default = {
    "centos" = "OpenLogic"
  }
}
locals {
  full_image_name            = "${var.image_name}-os-{{timestamp}}"
  full_image_name_enterprise = "${var.image_name}-ent-{{timestamp}}"
  ssh_username               = var.ssh_username
  version_tags               = { for k, v in yamldecode(file(var.hc_bin_versions)) : k => v if length(regexall(".*_version", k)) > 0 }
  tags                       = var.install_nomad ? local.version_tags : merge(local.version_tags, { "nomad_version" : "none" })
  image_sku                  = var.image_sku_map[var.linux_family]
  image_publisher            = var.image_publisher_map[var.linux_family]
}

source "azure-arm" "caravan" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  image_publisher = local.image_publisher
  image_sku       = local.image_sku

  build_resource_group_name = var.target_resource_group

  managed_image_resource_group_name = var.target_resource_group

  azure_tags = merge({
    owner     = "caravan-backing"
    managedBy = "packer"
    repo      = "github.com/bitrockteam/caravan-baking"
  }, local.tags)

  os_type         = "Linux"
  os_disk_size_gb = 30

  ssh_username = local.ssh_username

  vm_size = var.vm_size
}

build {
  name = "caravan"

  source "source.azure-arm.caravan" {
    name               = "opensource"
    managed_image_name = local.full_image_name
  }

  source "source.azure-arm.caravan" {
    name               = "enterprise"
    managed_image_name = local.full_image_name_enterprise
  }

  provisioner "shell" {
    inline = [
      "curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py",
      "if [ -x /usr/bin/python3 ]; then alias python='/usr/bin/python3'; fi",
      "python get-pip.py",
      "python -m pip install --user ansible==4.8.0"
    ]
  }

  provisioner "ansible-local" {
    playbook_file    = "../ansible/caravan.yml"
    playbook_dir     = "../ansible/"
    galaxy_file      = "../ansible/requirements.yml"
    inventory_groups = ["azure"]
    command          = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/${var.ssh_username}/.local/bin/ansible-playbook"
    galaxy_command   = "/home/${var.ssh_username}/.local/bin/ansible-galaxy"
    override = {
      enterprise = {
        inventory_groups = ["azure", "enterprise"]
      }
    }
    extra_arguments = [
      "--extra-vars", "install_nomad=${var.install_nomad}"
    ]
  }

  provisioner "shell" {
    script = "scripts/${var.linux_family}-cleanup.sh"
  }

  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }
}