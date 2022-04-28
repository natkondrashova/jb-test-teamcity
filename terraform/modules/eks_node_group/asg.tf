locals {
  node_groups_labels = flatten([
    for node_group_name, node_group_params in var.node_groups : [
      for label_key, label_value in lookup(node_group_params, "labels", {}) : {
        node_group_name = node_group_name
        label_key       = label_key
        label_value     = label_value
      }
    ]
  ])

  node_groups_taints = flatten([
    for node_group_name, node_group_params in var.node_groups : [
      for key, taint in lookup(node_group_params, "taints", {}) : {
        node_group_name = node_group_name
        taint_key       = taint.key
        taint_value     = "${taint.value}:${taint.effect}"
      }
    ]
  ])

  taint_effects_map = {
    "PreferNoSchedule" = "PREFER_NO_SCHEDULE"
    "NoExecute"        = "NO_EXECUTE"
    "NoSchedule"       = "NO_SCHEDULE"
  }
}

resource "aws_autoscaling_group_tag" "node_labels" {
  for_each               = { for item in local.node_groups_labels : "${item.label_key}-${item.node_group_name}" => item }
  autoscaling_group_name = aws_eks_node_group.workers[each.value.node_group_name].resources.0.autoscaling_groups.0.name

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/${each.value.label_key}"
    value               = each.value.label_value
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_group_tag" "node_taints" {
  for_each               = { for item in local.node_groups_taints : "${item.taint_key}-${item.node_group_name}" => item }
  autoscaling_group_name = aws_eks_node_group.workers[each.value.node_group_name].resources.0.autoscaling_groups.0.name

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/taint/${each.value.taint_key}"
    value               = each.value.taint_value
    propagate_at_launch = false
  }
}