include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../../modules/gke/cluster"
}

dependency "vpc_shared_01" {
  config_path                             = "../../../global/vpc/shared-01"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show", "destroy"]
  mock_outputs                            = {}
}

locals {
  name   = basename(get_terragrunt_dir())
  region = include.root.inputs.region

  kubernetes_version = "1.30.5-gke.1014003"
}

inputs = {
  name   = "k8s-${local.name}"
  region = local.region

  network    = "vnet-shared-01"
  subnetwork = "snet-k8s-01"

  ip_range_services = "k8s-services"
  ip_range_pods     = "k8s-pods"

  kubernetes_version = local.kubernetes_version

  node_pools = [
    {
      name               = "e2-standard-2"
      version            = local.kubernetes_version
      machine_type       = "e2-standard-2"
      min_count          = 1
      max_count          = 3
      initial_node_count = 1
      local_ssd_count    = 0
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      auto_upgrade       = true
    }
  ]
}
