data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 33.0.4"

  project_id = var.project_id

  deletion_protection = true

  name   = var.name
  region = var.region

  network    = var.network
  subnetwork = var.subnetwork

  ip_range_services = var.ip_range_services
  ip_range_pods     = var.ip_range_pods

  release_channel    = "STABLE"
  kubernetes_version = var.kubernetes_version

  remove_default_node_pool = true
  node_pools               = var.node_pools

  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = true
  config_connector           = true
  filestore_csi_driver       = false
  dns_cache                  = false
}
