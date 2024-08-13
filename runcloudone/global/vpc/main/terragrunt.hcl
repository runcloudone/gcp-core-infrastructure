include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-google-modules/network/google?version=9.1.0"
}

locals {
  name = basename(get_terragrunt_dir())
}

inputs = {
  network_name = local.name

  subnets = [
    {
      subnet_name           = "${local.name}-us-central1-subnet"
      subnet_ip             = "172.16.0.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    "${local.name}-us-central1-subnet" = [
      {
        range_name    = "gke-services"
        ip_cidr_range = "10.0.0.0/24"
      },
      {
        range_name    = "gke-pods"
        ip_cidr_range = "10.0.4.0/22"
      }
    ]
  }
}
