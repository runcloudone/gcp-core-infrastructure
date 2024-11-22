module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  for_each = var.service_accounts

  project_id = var.project_id

  names         = [each.key]
  prefix        = each.value.prefix
  project_roles = each.value.project_roles
}
