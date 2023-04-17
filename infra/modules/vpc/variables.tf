variable "name_prefix" {
  type = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type = list
  default = ["10.0.4.0/24","10.0.4.0/24"]
}
