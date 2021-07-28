variable "source_path" {
  type    = string
  default = "bento/centos-7"
}

variable "provider" {
  type    = string
  default = "virtualbox"
}

variable "image_name" {
  type    = string
  default = "caravan-centos-image"
}

variable "install_nomad" {
  type    = bool
  default = true
}

locals {
  full_image_name            = "${var.image_name}-os-{{timestamp}}"
  full_image_name_enterprise = "${var.image_name}-ent-{{timestamp}}"
}

source "vagrant" "centos_7" {
  source_path  = var.source_path
  provider     = var.provider
  communicator = "ssh"
}

build {
  name = "caravan"

  source "source.vagrant.centos_7" {
    name     = "opensource"
    box_name = local.full_image_name
  }

  source "source.vagrant.centos_7" {
    name     = "enterprise"
    box_name = local.full_image_name_enterprise
  }

  provisioner "shell" {
    inline = [
      "curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py",
      "python get-pip.py",
      "python -m pip install --user ansible==2.10.7"
    ]
  }

  provisioner "ansible-local" {
    playbook_file       = "../ansible/centos.yml"
    playbook_dir        = "../ansible/"
    galaxy_file         = "../ansible/requirements.yml"
    command             = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/centos/.local/bin/ansible-playbook"
    galaxy_command      = "/home/centos/.local/bin/ansible-galaxy"
    override = {
      enterprise = {
        inventory_groups = ["enterprise"]
      }
    }
    extra_arguments = [
      "--extra-vars", "install_nomad=${var.install_nomad}"
    ]
  }

  provisioner "shell" {
    script = "scripts/centos-cleanup.sh"
  }

  provisioner "shell" {
    inline            = ["sudo reboot"]
    expect_disconnect = true
  }
}
