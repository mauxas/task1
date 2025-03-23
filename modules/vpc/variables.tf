variable "disk_size" {
  description = "Disk size of worker node group"
  type        = number
  default     = 50
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

variable "subnet_groups" {
  description = "Subnet groups with AZ indexes and CIDR blocks"
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
