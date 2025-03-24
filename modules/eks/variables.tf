variable "cluster_name" {
  description = "Name used across created resources for cluster"
  type        = string
  default     = "matas-eks"
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
  default = {
    "capability_name" = "eks"
    "stage"           = "dev"
    "slack_channel"   = "sre-infra"
    "team"            = "sre"
  }
}

variable "node_groups" {
  description = <<-EOT
    A map of node groups to create for the EKS cluster, with their configurations.

    Each key in the map represents the name of a node group. The value is an object containing the configuration for that node group.

    Node Group Configuration:
    - node_group_name: The name of the node group.
    - desired_size: The desired number of nodes in the node group.
    - maximum_size: The maximum number of nodes allowed in the node group.
    - minimum_size: The minimum number of nodes allowed in the node group.
    - disk_size: The disk size (in GiB) for the nodes' root volume.
    - instance_types: A list of EC2 instance types to use for the nodes.
    - tags: A map of tags to apply to the node group's resources.

  EOT
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
      desired_size    = 4
      maximum_size    = 5
      minimum_size    = 1
      disk_size       = 50
      instance_types  = ["t3.micro"]
      tags = {
        capability_name = "eks"
        stage           = "dev"
        slack_channel   = "sre-infra"
        team            = "sre"
      }
    }
  }
}