output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_auth_token" {
  description = "Kubernetes cluster authentication token"
  value       = data.aws_eks_cluster_auth.this.token
}

output "cluster_ca_certificate" {
  description = "Kubernetes cluster ca certificate"
  value       = base64decode(module.eks.cluster_certificate_authority_data)
}
