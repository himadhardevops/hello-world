variable "namespace" {
  default = "argocd-image-updater"
}

variable "app_namespace" {
  default = "hello-world"
}

variable "aws_region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "cluster_endpoint" {
  description = "host for a kubernetes provider"
  type        = string
}

variable "cluster_auth_token" {
  description = "Kubernetes cluster authentication token"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Kubernetes cluster ca certificate"
  type        = string
}

variable "name_prefix" {
  type = string
}
