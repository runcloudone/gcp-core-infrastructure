include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google?version=32.0.0"
}

dependency "vpc_shared_01" {
  config_path                             = "../../../global/vpc/shared-01"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show", "destroy"]
  mock_outputs                            = {}
}

locals {
  name   = basename(get_terragrunt_dir())
  region = include.root.inputs.region

  network_name    = "vnet-shared-01"
  subnetwork_name = "snet-k8s-01"
}

inputs = {
  name   = "k8s-${local.name}"
  region = local.region

  network    = local.network_name
  subnetwork = local.subnetwork_name

  ip_range_services = "k8s-services"
  ip_range_pods     = "k8s-pods"

  release_channel     = "UNSPECIFIED"
  kubernetes_version  = "1.29.7-gke.1104000"
  deletion_protection = false

  remove_default_node_pool = true
  node_pools = [
    {
      name               = "default-pool"
      version            = "1.29.7-gke.1104000"
      machine_type       = "e2-standard-2"
      min_count          = 1
      max_count          = 3
      initial_node_count = 1
      local_ssd_count    = 0
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      auto_upgrade       = false
    }
  ]

  config_connector = true
}
