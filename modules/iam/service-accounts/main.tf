module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  for_each = var.service_accounts

  project_id = var.project_id

  names         = [each.key]
  prefix        = each.value.prefix
  project_roles = each.value.project_roles
}

resource "google_service_account_iam_member" "workload_identity" {
  for_each = {
    for sa, props in var.service_accounts :
    sa => props.workload_identity if props.workload_identity != null
  }

  service_account_id = module.service_accounts[each.key].service_account.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value.namespace}/${each.value.name}]"
}
