terraform {
  required_version = "~> 0.14.0"
}

resource "null_resource" "run_packer_google" {
  count = (var.build_on_google && ! var.skip_packer_build) ? 1 : 0
  provisioner "local-exec" {
    working_dir = path.module
    command     = "packer build -force -var-file versions.json packer-centos-gcp.json"
    environment = {
      GOOGLE_IMAGE_NAME      = var.build_image_name
      GOOGLE_MACHINE_TYPE    = var.build_machine_type
      GOOGLE_REGION          = var.build_region
      GOOGLE_ZONE            = var.build_zone
      GOOGLE_ACCOUNT_FILE    = var.google_account_file
      GOOGLE_PROJECT_ID      = var.google_project_id
      GOOGLE_NETWORK_NAME    = var.google_network_name
      GOOGLE_SUBNETWORK_NAME = var.google_subnetwork_name
      GOOGLE_FIREWALL_NAME   = var.google_firewall_name
      PKG_LIST               = join(" ", var.pkg_list)
      NAMESERVERS            = join(" ", var.nameservers)
      DUMMY_IP               = var.dummy_ip
      INSTALL_ENVOY          = "yes"
      INSTALL_CNI            = "yes"
      INSTALL_DOCKER         = "yes"
      ENABLE_DOCKER_LOGIN    = "yes"
      INSTALL_PROMETHEUS     = "yes"
      INSTALL_GRAFANA        = "yes"
      INSTALL_JAEGER         = "yes"
      INSTALL_ELASTIC        = "yes"
    }
  }
}