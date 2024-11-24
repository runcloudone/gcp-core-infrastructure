include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/dns"
}

locals {
  project_id = include.root.inputs.project_id
}

inputs = {
  project_id = local.project_id
  zones = {
    "runcloudone-com" = {
      domain = "runcloudone.com.",
      type   = "public"
    }
  }
}
