output "cluster_name" {
  value      = aws_eks_cluster.this.id
  depends_on = [null_resource.waiter]
}

output "cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "node_role" {
  value = aws_iam_role.node_role
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

output "cluster_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.cluster.arn
}
