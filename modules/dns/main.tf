module "cloud_dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.3.0"

  for_each = var.zones

  project_id = var.project_id

  name        = each.key
  domain      = each.value.domain
  type        = each.value.type
  description = each.value.description

  recordsets = each.value.recordsets

  labels = each.value.labels
}
