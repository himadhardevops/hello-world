module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
#  cluster_encryption_config = [
#    {
#      provider_key_arn = var.aws_kms_key_arn
#      resources        = ["secrets"]
#    }
#  ]
  worker_create_cluster_primary_security_group_rules = true
  cluster_create_security_group                      = true
  vpc_id                                             = var.vpc_id 
  subnets                                            = var.subnets

  workers_group_defaults = { root_volume_type = "gp2" }
  node_groups = {
   system-pods = {
    desired_capacity = 1 
    max_capacity     = 1 
    min_capaicty     = 1

    instance_type = "t2.medium"
    }
   gpu-application = {
    desired_capacity = 1
    max_capacity     = 1
    min_capaicty     = 1

    instance_type = "t2.medium"
    }
   cpu-application = {
    desired_capacity = 1
    max_capacity     = 1
    min_capaicty     = 1

    instance_type = "t2.medium"
    }
  }
}

resource "local_file" "kubeconfig" {
  content = data.template_file.kubeconfig.rendered
  filename = "${path.module}/eks-cluster-config.yaml"
}

data "template_file" "kubeconfig" {
  template = <<EOF
apiVersion: v1
kind: Config
current-context: terraform
clusters:
- name: ${module.eks.cluster_id}
  cluster:
    certificate-authority-data: ${data.aws_eks_cluster.this.certificate_authority[0].data}
    server: ${data.aws_eks_cluster.this.endpoint}
contexts:
- name: terraform
  context:
    cluster: ${module.eks.cluster_id}
    user: terraform
users:
- name: terraform
  user:
    token: ${data.aws_eks_cluster_auth.this.token}
EOF
}

# resource "null_resource" "unset_default_storageclass" {
#   provisioner "local-exec" {
#     command = "kubectl patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}' --kubeconfig=${local_file.kubeconfig.filename}"
#   }
# }
# 
# resource "null_resource" "set_default_storageclass" {
#   provisioner "local-exec" {
#     command = "kubectl patch storageclass efs-sc -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}' --kubeconfig=${local_file.kubeconfig.filename}"
#   }
# }

locals {
  cluster_name = var.name_prefix
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}
