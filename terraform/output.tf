locals {
  V01_load_versions_from_file = merge({ for k, v in yamldecode(file(var.apps_bin_versions)) : k => v if length(regexall(".*_version", k)) > 0 }, { for k, v in yamldecode(file(var.hc_bin_versions)) : k => v if length(regexall(".*_version", k)) > 0 })
  V02_remove_nomad            = var.install_nomad ? local.V01_load_versions_from_file : merge(local.V01_load_versions_from_file, { "nomad_version" : "none" })

  final_versions = local.V02_remove_nomad
}

output "installed_versions" {
  value       = local.final_versions
  description = "List of each component and version."
}
