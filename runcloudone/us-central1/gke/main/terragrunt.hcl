include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google?version=32.0.0"
}

dependency "vpc_main" {
  config_path                             = "../../../global/vpc/main"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show", "destroy"]
  mock_outputs                            = {}
}

locals {
  name   = basename(get_terragrunt_dir())
  region = include.root.inputs.region

  network_name    = "main"
  subnetwork_name = "${local.network_name}-${local.region}-subnet"
}

inputs = {
  name   = local.name
  region = local.region

  network    = local.network_name
  subnetwork = local.subnetwork_name

  ip_range_services = "gke-services"
  ip_range_pods     = "gke-pods"

  release_channel     = "UNSPECIFIED"
  kubernetes_version  = "1.27.16-gke.1008000"
  deletion_protection = false

  remove_default_node_pool = true
  node_pools = [
    {
      name               = "default-pool"
      version            = "1.27.16-gke.1008000"
      machine_type       = "e2-standard-2"
      min_count          = 1
      max_count          = 3
      initial_node_count = 1
      local_ssd_count    = 0
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      auto_upgrade       = false
      node_locations     = "us-central1-b,us-central1-c,us-central1-f"
    }
  ]
}
