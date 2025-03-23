variable "helm_releases" {
  description = "A map of Helm releases to deploy from local charts."
  type = map(object({
    name        = string
    chart_path  = string
    values_file = string
    namespace   = optional(string, "default") # Optional namespace, defaults to "default"
    # Add other helm_release options as needed
  }))
  default = {
    "receiver" = {
      name        = "receiver"
      chart_path  = "../../helm/receiver"
      values_file = "receiver-values.yaml" # example values file name.
      namespace   = "my-namespace"         # example namespace.
    }
  }
}

variable "helm_releases_tests" {
  description = "A map of Helm releases to deploy from local charts."
  type = map(object({
    name        = string
    chart_path  = string
    values_file = string
    namespace   = optional(string, "default") # Optional namespace, defaults to "default"
    # Add other helm_release options as needed
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  description = <<-EOT
    A map of tags to apply to all AWS resources.

    Tags are key-value pairs that provide metadata for your AWS resources. They help you organize and identify resources for various purposes, such as cost allocation, automation, and security.

    Example:
    tags = {
      capability_name = "eks"
      stage           = "dev"
      slack_channel   = "sre-infra"
      team            = "sre"
    }

  EOT
  default = {}
}