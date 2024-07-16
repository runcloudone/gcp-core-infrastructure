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
  network_name = "${local.name}-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "${local.name}-us-central1-subnet"
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
    }
  ]
}
