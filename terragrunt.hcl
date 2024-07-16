locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl", "${get_terragrunt_dir()}/project.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl", "${get_terragrunt_dir()}/region.hcl"))

  project_id     = local.project_vars.locals.project_id
  default_region = local.project_vars.locals.default_region
  region         = local.region_vars.locals.region
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile("provider.tf.tpl", {
    project_id = local.project_id
    region     = local.region
  })
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    project  = local.project_id
    location = local.default_region
    bucket   = lower("${local.project_id}-tf-states")
    prefix   = "${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  project_id = local.project_id
  region     = local.region
  default_labels = {
    "OwnerEmail" = "ilya.melnik.svc@gmail.com"
  }
}
