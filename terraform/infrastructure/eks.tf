module "eks_cluster" {
  source               = "../modules/eks_cluster"
  eks_cluster_name     = local.cluster_name
  eks_version          = var.eks_version
  subnet_ids           = module.vpc.private_subnets
  oidc_thumbprint_list = []
}

module "eks_node_group" {
  source = "../modules/eks_node_group"

  eks_version = var.eks_version

  cluster_name              = module.eks_cluster.cluster_name
  cluster_ca                = module.eks_cluster.cluster_ca
  cluster_endpoint          = module.eks_cluster.cluster_endpoint
  cluster_security_group_id = module.eks_cluster.cluster_security_group_id

  node_role_arn = module.eks_cluster.node_role.arn
  subnets       = module.vpc.private_subnets
  node_groups   = local.node_groups
}

