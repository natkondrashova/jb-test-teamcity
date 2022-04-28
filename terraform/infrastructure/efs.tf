resource "aws_efs_file_system" "this" {}

resource "aws_efs_mount_target" "this" {
  for_each        = { for idx, cidr in var.vpc_private_subnets : idx => cidr }
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = module.vpc.private_subnets[each.key]
  security_groups = [module.eks_cluster.cluster_security_group_id]

  depends_on      = [module.vpc.private_subnets, module.eks_cluster.cluster_security_group_id]
}
