variable "cluster_name" {
  description = "Name used across created resources"
  type        = string
  default     = "matas-eks"
}

variable "node_group_name" {
  description = "Name used for node group naming"
  type        = string
  default     = "worker"
}

variable "disk_size" {
  description = "Disk size of worker node group"
  type        = number
  default     = 50
}

variable "instance_types" {
  description = "Instance type of worker node group"
  type        = list(string)
  default     = ["t3.medium"]
}

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

variable "node_groups" {
  description = "A map of node groups to create, with their configurations."
  type = map(object({
    node_group_name = string
    desired_size    = number
    maximum_size    = number
    minimum_size    = number
    disk_size       = number
    instance_types  = list(string)
    tags            = map(string)
  }))
  default = {
    "workers" = {
      node_group_name = "worker"
      desired_size    = 2
      maximum_size    = 5
      minimum_size    = 1
      disk_size       = 50
      instance_types  = ["t3.medium"]
      tags = {
        capability_name = "eks"
        stage           = "dev"
        slack_channel   = "sre-infra"
        team            = "sre"
      }
    }
  }
}

variable "cidr_block" {
  description = "Cidr range for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "Instance tenancy"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Toggle for enabling dns hostnames"
  type        = bool
  default     = true
}

variable "health_probe_bind_address" {
  description = "Toggle for enabling dns hostnames"
  type        = string
  default     = "8163"
}

variable "metrics_bind_address" {
  description = "Toggle for enabling dns hostnames"
  type        = string
  default     = "8162"
}