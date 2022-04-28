resource "aws_eks_node_group" "workers" {
  for_each        = var.node_groups
  cluster_name    = var.cluster_name
  node_group_name = join("-", [each.key, var.cluster_name, random_id.this[each.key].id])
  node_role_arn   = var.node_role_arn

  launch_template {
    id      = aws_launch_template.workers[each.key].id
    version = aws_launch_template.workers[each.key].latest_version
  }

  subnet_ids = var.subnets
  tags       = var.tags

  scaling_config {
    desired_size = lookup(each.value, "desired_size", each.value.min_size)
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  labels = lookup(each.value, "labels", {})

  dynamic "taint" {
    for_each = lookup(each.value, "taints", {})

    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = local.taint_effects_map[taint.value.effect]
    }
  }


  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }
}

//the keepers should be events that lead to the re-creation of the node group in AWS, not the update
resource "random_id" "this" {
  for_each = var.node_groups
  keepers = {
    launch_template = aws_launch_template.workers[each.key].id
    node_role_arn   = var.node_role_arn
    subnet_ids      = join(" ", var.subnets)
  }

  byte_length = 8
}