locals {
  oidc_provider = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")

  irsa_maps = [
    {
      ns         = var.tenant_name
      sa         = "server"
      policy_arn = aws_iam_policy.tc_server.arn
    },
  ]
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

resource "aws_iam_role" "irsa_iam_role" {
  for_each = { for irsa_map in local.irsa_maps : "${irsa_map.ns}-${irsa_map.sa}" => irsa_map }
  name     = "${data.aws_eks_cluster.this.name}-${var.tenant_name}-${each.value.ns}-${each.value.sa}"

  // TODO: data.aws_iam_policy_document
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${local.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${local.oidc_provider}:sub": "system:serviceaccount:${each.value.ns}:${each.value.sa}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "irsa_iam_policy_attachment" {
  for_each   = { for irsa_map in local.irsa_maps : "${irsa_map.ns}-${irsa_map.sa}" => irsa_map }
  role       = "${data.aws_eks_cluster.this.name}-${var.tenant_name}-${each.value.ns}-${each.value.sa}"
  policy_arn = each.value.policy_arn
  depends_on = [aws_iam_role.irsa_iam_role]
}

data "aws_iam_policy_document" "tc_server" {
  # TODO: minimize permissions
  statement {
    effect = "Allow"
    sid    = "1"
    actions = [
      "rds:*"
    ]
    resources = [
      aws_db_instance.tenant.arn
    ]
  }
  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.tenant.arn,
      "${aws_s3_bucket.tenant.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "tc_server" {
  name_prefix = "${var.tenant_name}-server"
  description = "Allow server pods work with rds,s3"
  policy      = data.aws_iam_policy_document.tc_server.json
}


