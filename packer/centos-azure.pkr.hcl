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

variable "image_sku" {
  type    = string
  default = "7_9-gen2"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

locals {
  full_image_name            = "${var.image_name}-os-{{timestamp}}"
  full_image_name_enterprise = "${var.image_name}-ent-{{timestamp}}"
  ssh_username               = "centos"
}

source "azure-arm" "centos_7" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  image_publisher = "OpenLogic"
  image_offer     = "CentOS"
  image_sku       = var.image_sku

  build_resource_group_name = var.target_resource_group

  managed_image_resource_group_name = var.target_resource_group

  azure_tags = {
    owner     = "caravan-backing"
    managedBy = "packer"
    repo      = "github.com/bitrockteam/caravan-baking"
  }

  os_type         = "Linux"
  os_disk_size_gb = 30

  ssh_username = local.ssh_username

  vm_size = var.vm_size
}

build {
  name = "caravan"

  source "source.azure-arm.centos_7" {
    name               = "opensource"
    managed_image_name = local.full_image_name
  }

  source "source.azure-arm.centos_7" {
    name               = "enterprise"
    managed_image_name = local.full_image_name_enterprise
  }

  provisioner "shell" {
    inline = [
      "curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py",
      "python get-pip.py",
      "python -m pip install --user ansible==2.10.7"
    ]
  }

  provisioner "ansible-local" {
    playbook_file       = "../ansible/centos-azure.yml"
    playbook_dir        = "../ansible/"
    galaxy_file         = "../ansible/requirements.yml"
    inventory_groups    = ["centos_azure"]
    command             = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/centos/.local/bin/ansible-playbook"
    galaxy_command      = "/home/centos/.local/bin/ansible-galaxy"
    override = {
      enterprise = {
        inventory_groups = ["centos_azure", "enterprise"]
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
