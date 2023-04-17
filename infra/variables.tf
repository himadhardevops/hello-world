variable "aws_region" {
  default = "us-west-2"
}

variable "cluster_version" {
  type    = string
  default = "1.23"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "registry_name" {
  type    = string
  default = "hello_world_reg"
}

variable "node_groups" {
  type = map(object({
    min_size      = number
    max_size      = number
    desired_size  = number
    instance_type = string
  }))
  description = "Managed node group information"
  default = {
    "system-pods" = {
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      instance_type = "t2.medium"
    }

    "cpu-application" = {
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      instance_type = "t2.medium"
    }

    "gpu-application" = {
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      instance_type = "t2.medium"
    }
  }
}
