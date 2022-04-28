output "region" {
  value = var.region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "irsa_roles" {
  value = { for k, r in aws_iam_role.irsa_iam_role : k => r.arn }
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets[*]
}

output "public_subnets" {
  value = var.vpc_public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets[*]
}

output "private_subnets" {
  value = var.vpc_private_subnets
}

output "mysql_subnet_group" {
  value = aws_db_subnet_group.this.name
}

output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "main_dns_zone" {
  value = aws_route53_zone.this.name
}

output "security_group_id" {
  value = module.eks_cluster.cluster_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks_cluster.cluster_oidc_provider_arn
}
