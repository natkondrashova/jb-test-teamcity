resource "aws_cloudwatch_log_group" "filebeat" {
  name              = "/tc/clients/${data.aws_eks_cluster.this.id}/${var.tenant_name}"
  retention_in_days = var.cloudwatch_retention_in_days
}
