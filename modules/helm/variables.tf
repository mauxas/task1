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
  description = <<-DESC
  A map of tags to add to all resources.
  Tags are key-value pairs that help in organizing and identifying AWS resources.
  Ensure to provide meaningful tags for better resource management.

  Example:
  tags = {
    "environment"   = var.name
    "stage"         = "dev"
    "slack_channel" = "sre-infra"
    "team"          = "sre"
  }
  DESC
  default     = {}
}