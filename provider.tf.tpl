variable "default_labels" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource"
}

provider "google" {
  project        = "${project_id}"
  region         = "${region}"
  default_labels = var.default_labels
}
