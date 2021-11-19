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

variable "image_prefix" {
  type    = string
  default = "caravan"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
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

variable "aws_product_code_map" {
  type = map(string)
  default = {
    "ubuntu" = "97hj1xofcw6i97ku4fsxqayy4",
    "centos" = "cvugziknvmxgqna9noibqnnsy",
    "rocky"  = "cotnnspjrsi38lfn8qo4ibnnm"
  }
}

locals {
  linux_distro               = "${var.linux_os}-${var.linux_os_version}"
  full_image_name            = "${var.image_prefix}-os-${local.linux_distro}-{{timestamp}}"
  full_image_name_enterprise = "${var.image_prefix}-ent-${local.linux_distro}-{{timestamp}}"
  ssh_username               = var.ssh_username
  version_tags               = merge({ for k, v in yamldecode(file(var.apps_bin_versions)) : k => v if length(regexall(".*_version", k)) > 0 }, { for k, v in yamldecode(file(var.hc_bin_versions)) : k => v if length(regexall(".*_version", k)) > 0 })
  tags                       = var.install_nomad ? local.version_tags : merge(local.version_tags, { "nomad_version" : "none" })
  aws_product_code           = var.aws_product_code_map[var.linux_os]
}

source "amazon-ebs" "caravan" {
  access_key    = var.access_key
  secret_key    = var.secret_key
  region        = var.region
  instance_type = var.instance_type

  ami_regions = [var.region]

  ssh_username = local.ssh_username
  tags = merge({
    Owner = "packer-builder-caravan"
  }, local.tags)

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      product-code        = local.aws_product_code
    }
    owners      = ["aws-marketplace"]
    most_recent = true
  }

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_type           = "gp2"
    volume_size           = 20
  }
}

build {
  name = "caravan"

  source "source.amazon-ebs.caravan" {
    name = "opensource"

    ami_name        = local.full_image_name
    ami_description = "Caravan ${local.linux_distro}"
  }

  source "source.amazon-ebs.caravan" {
    name = "enterprise"

    ami_name        = local.full_image_name_enterprise
    ami_description = "Caravan ${local.linux_distro} - Enterprise"
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
    inventory_groups = ["aws"]
    command          = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/${var.ssh_username}/.local/bin/ansible-playbook"
    galaxy_command   = "/home/${var.ssh_username}/.local/bin/ansible-galaxy"
    override = {
      enterprise = {
        inventory_groups = ["aws", "enterprise"]
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
