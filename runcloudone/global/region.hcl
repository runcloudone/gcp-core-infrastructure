locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region       = local.project_vars.locals.default_region
}
