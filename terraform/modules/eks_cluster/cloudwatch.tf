resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.log_retention_in_days
}
