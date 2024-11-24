variable "project_id" {
  type        = string
  description = "Project id where service account will be created."
}

variable "zones" {
  type = map(object({
    domain      = string,
    description = optional(string),
    type        = optional(string, "public"),
    recordsets = optional(list(object({
      name    = string,
      type    = string,
      ttl     = number,
      records = list(string),
    })), []),
    labels = optional(map(string), {}),
  }))
  description = "DNS zones to create in the project"
  default     = {}
}
