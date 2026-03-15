variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "workshop"
  }
}

variable "assume_role" {
  type = object({
    arn    = string
    region = string
  })

  default = {
    arn    = "arn:aws:iam::196338543880:role/evandromelos-role"
    region = "us-east-1"
  }
}

variable "ecr_repositories" {
  description = "A list of ECR repositories to create"
  type        = list(string)
  default = [
    "workshop-frontend",
    "workshop-backend",
  ]
}

variable "node_group_instance_types" {
  description = "Instance types used by the managed node group"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "node_group_capacity_type" {
  description = "Capacity type for the managed node group (SPOT avoids On-Demand Fleet Request quota)"
  type        = string
  default     = "SPOT"
}

variable "node_group_disk_size" {
  description = "Disk size (GiB) for each managed node"
  type        = number

  validation {
    condition     = var.node_group_disk_size >= 20
    error_message = "EKS managed node groups using the default AL2023 AMI require at least 20 GiB of disk."
  }
  default = 20
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the managed node group"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the managed node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the managed node group"
  type        = number
  default     = 2
}

variable "node_group_max_unavailable" {
  description = "How many nodes can be unavailable during node group updates"
  type        = number
  default     = 2
}

variable "node_group_scale_to_zero" {
  description = "Temporarily scale node group to zero (useful before destroying cluster)"
  type        = bool
  default     = false
}
