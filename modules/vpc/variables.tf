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


variable "cidr_block" {
  description = <<-EOT
    The CIDR block for the VPC (Virtual Private Cloud).

    This specifies the range of private IP addresses that will be used within the VPC.
    It's crucial to choose a CIDR block that does not overlap with other networks that you might need to connect to,
    such as on-premises networks or other VPCs.
  EOT
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = <<-EOT
    The instance tenancy setting for the VPC.

    This determines how EC2 instances are allocated within the VPC.
    Available options are:
    - 'default': Instances are launched on shared hardware.
    - 'dedicated': Instances are launched on hardware dedicated to a single customer.
    - 'host': Instances are launched on dedicated hardware with EC2 host tenancy.

    'default' is the most cost-effective option and is suitable for most workloads.
    'dedicated' and 'host' provide greater isolation and are typically used for compliance or performance reasons.

  EOT
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = <<-EOT
    A boolean flag to enable DNS hostnames for the VPC.

    When enabled, EC2 instances within the VPC will be assigned public DNS hostnames.
    This allows instances to be addressed using human-readable names instead of IP addresses.
  EOT
  type        = bool
  default     = true
}

variable "health_probe_bind_address" {
  description = <<-EOT
    The port number to which the health probe listener will bind.

    This setting is used to configure a health probe that monitors the availability of a service or application.
    The health probe listens on the specified port for incoming requests.

  EOT
  type        = string
  default     = "8163"
}

variable "metrics_bind_address" {
  description = <<-EOT
    The port number to which the metrics listener will bind.

    This setting is used to configure a metrics endpoint that exposes performance or operational metrics.
    The metrics listener listens on the specified port for incoming requests.

  EOT
  type        = string
  default     = "8162"
}
variable "subnet_groups" {
  description = <<-EOT
    A map defining subnet groups for the VPC, with their Availability Zone indexes, CIDR blocks, and privacy settings.

    This variable allows you to define multiple subnet groups, each with its own configuration.
    Subnet groups are used to organize subnets within the VPC and control their network access.

    Each key in the map represents the name of a subnet group (e.g., "private", "public").
    The value is an object containing the configuration for that subnet group.

    Subnet Group Configuration:
    - az_indexes: A list of Availability Zone indexes (e.g., [0, 1]).
      These indexes correspond to the Availability Zones in the AWS region.
      For example, if the AWS region has three Availability Zones (a, b, c),
      then index 0 represents "a", index 1 represents "b", and index 2 represents "c".
    - cidr_blocks: A list of CIDR blocks for the subnets within the group (e.g., ["10.0.1.0/24", "10.0.2.0/24"]).
      Each CIDR block defines the range of private IP addresses for a subnet.
    - is_private: A boolean flag indicating whether the subnets in the group are private (true) or public (false).
      Private subnets have no direct internet access, while public subnets can have internet access through an Internet Gateway.
  EOT
  type = map(object({
    az_indexes  = list(number)
    cidr_blocks = list(string)
    is_private  = bool
  }))
  default = {
    "private" = {
      az_indexes  = [0, 1],
      is_private  = true,
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    },
    "public" = {
      az_indexes  = [0],
      is_private  = false,
      cidr_blocks = ["10.0.3.0/24"]
    },
  }
}
