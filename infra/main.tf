module "vpc" {
  source          = "./modules/vpc"
  name_prefix     = local.cluster_name
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  name_prefix     = local.cluster_name
  node_groups     = var.node_groups
  tags            = local.tags
}

 module "app" {
   source                 = "./modules/app"
   cluster_endpoint       = module.eks.cluster_endpoint
   cluster_auth_token     = module.eks.cluster_auth_token
   cluster_ca_certificate = module.eks.cluster_ca_certificate
   name_prefix            = local.cluster_name
 }
