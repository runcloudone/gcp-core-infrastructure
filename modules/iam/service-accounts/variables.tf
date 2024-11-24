variable "project_id" {
  type        = string
  description = "Project id where service account will be created."
}

variable "service_accounts" {
  type = map(object({
    prefix        = optional(string, "tf-sa")
    project_roles = optional(list(string), [])
    workload_identity = optional(object({
      namespace = string
      name      = string
    }))
  }))
  description = "Service accounts to create in the project"
  default     = {}
}
