variable "tags" {
  type        = map(string)
  description = <<-DESC
  A map of tags to add to all resources.
  Tags are key-value pairs that help in organizing and identifying AWS resources.
  Ensure to provide meaningful tags for better resource management.

  Example:
  tags = {
    "capability_name"   = var.name
    "stage"         = "dev"
    "slack_channel" = "sre-infra"
    "team"          = "sre"
  }
  DESC
  default     = {
    "capability_name"   = "eks"
    "stage"         = "dev"
    "slack_channel" = "sre-infra"
    "team"          = "sre"
  }
}