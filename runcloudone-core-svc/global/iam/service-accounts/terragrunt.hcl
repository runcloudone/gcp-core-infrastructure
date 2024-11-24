include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../../modules/iam/service-accounts"
}

locals {
  project_id = include.root.inputs.project_id
}

inputs = {
  project_id = local.project_id
  service_accounts = {
    "external-dns" = {
      display_name  = "External DNS"
      description   = "Service account for External DNS"
      project_roles = ["${local.project_id}=>roles/dns.admin"]
      workload_identity = {
        namespace = "external-dns"
        name      = "external-dns"
      }
    }
  }
}
