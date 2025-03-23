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
    default = {
    "capability_name" = "eks"
    "stage"           = "dev"
    "slack_channel"   = "sre-infra"
    "team"            = "sre"
  }
}