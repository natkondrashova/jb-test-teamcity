#locals {
#  node_roles = [
#    {
#      rolearn  = aws_iam_role.node_role.arn
#      username = "system:node:{{EC2PrivateDNSName}}"
#      groups = tolist(
#        [
#          "system:bootstrappers",
#          "system:nodes",
#        ]
#      )
#    }
#  ]
#  admin_roles = [
#    for role in var.admin_roles : {
#      rolearn  = role
#      username = "admin"
#      groups   = tolist(["system:masters"])
#    }
#  ]
#  additional_roles = [
#    for item in var.custom_aws_auth_roles : {
#      rolearn  = item["rolearn"]
#      username = item["username"]
#      groups   = tolist(item["groups"])
#    }
#  ]
#}
#
#resource "kubernetes_config_map" "aws_auth" {
#  depends_on = [null_resource.waiter]
#
#  // TODO: Temp!!! Delete this
#  lifecycle { ignore_changes = [data] }
#
#  metadata {
#    name      = "aws-auth"
#    namespace = "kube-system"
#  }
#
#  data = {
#    mapRoles = yamlencode(concat(
#      local.node_roles,
#      local.admin_roles,
#      local.additional_roles
#      )
#    )
#  }
#}
