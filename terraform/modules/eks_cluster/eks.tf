resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.eks_version

  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    subnet_ids              = var.subnet_ids
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.this
  ]
}

resource "null_resource" "waiter" {
  depends_on = [
    aws_eks_cluster.this
  ]

  provisioner "local-exec" {
    command     = "for i in {1..60}; do curl -sk $ENDPOINT/healthz >/dev/null && exit 0 || true; sleep 5; done; echo \"api-server doesn't respond\" && exit 1"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      ENDPOINT = aws_eks_cluster.this.endpoint
    }
  }
}
