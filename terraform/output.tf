output "installed_versions" {
  value       = merge({ for k, v in yamldecode(file("../ansible/roles/hc_stack_apps/defaults/main.yml")) : k => v if length(regexall(".*_version", k)) > 0 }, { for k, v in yamldecode(file("../ansible/roles/hc_stack_install/defaults/main.yml")) : k => v if length(regexall(".*_version", k)) > 0 })
  description = "List of each component and version."
}
