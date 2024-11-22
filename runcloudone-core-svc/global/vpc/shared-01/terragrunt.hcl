include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-google-modules/network/google?version=9.3.0"
}

locals {
  name = basename(get_terragrunt_dir())
}

inputs = {
  network_name = "vnet-${local.name}"

  subnets = [
    {
      subnet_name           = "snet-k8s-01"
      subnet_ip             = "172.16.0.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    "snet-k8s-01" = [
      {
        range_name    = "k8s-services",
        ip_cidr_range = "10.0.0.0/24"
      },
      {
        range_name    = "k8s-pods",
        ip_cidr_range = "10.0.4.0/22"
      }
    ]
  }
}
