data "template_file" "user_data" {
  template = file("${path.module}/files/userdata.sh.tpl")
  vars = {
    cluster_auth_base64 = var.cluster_ca
    endpoint            = var.cluster_endpoint
    cluster_name        = var.cluster_name
    pre_userdata        = var.pre_userdata
    post_userdata       = var.post_userdata
  }
}

resource "aws_launch_template" "workers" {
  for_each      = var.node_groups
  name_prefix   = "${var.cluster_name}-${each.key}-lt"
  image_id      = lookup(each.value, "image_id", local.default_image_id)
  instance_type = lookup(each.value, "instance_type", var.default_instance_type)
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = concat([var.cluster_security_group_id], var.worker_security_group_ids)
  }
  user_data = base64encode(data.template_file.user_data.rendered)
  tags      = var.tags
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      "Name" : "${var.cluster_name}-${each.key}-worker"
    })
  }
  key_name = var.ssh_key

  block_device_mappings {
    device_name = lookup(each.value, "root_device_name", local.default_root_device_name)
    ebs {
      volume_type = lookup(each.value, "root_device_type", var.default_volume_type)
      volume_size = lookup(each.value, "root_device_size", var.default_volume_size)
      encrypted   = lookup(each.value, "root_volume_encrypted", var.default_volume_encrypted)
      kms_key_id  = lookup(each.value, "root_kms_key_id", var.default_kms_key_id)
    }
  }

  dynamic "block_device_mappings" {
    for_each = lookup(each.value, "additional_ebs", "") == "" ? var.common_ebs : merge(var.common_ebs, lookup(each.value, "additional_ebs"))
    content {
      device_name = block_device_mappings.key
      ebs {
        volume_type           = lookup(block_device_mappings.value, "volume_type", var.default_volume_type)
        volume_size           = lookup(block_device_mappings.value, "volume_size", var.default_volume_size)
        encrypted             = lookup(block_device_mappings.value, "volume_encrypted", var.default_volume_encrypted)
        kms_key_id            = lookup(block_device_mappings.value, "kms_key_id", var.default_kms_key_id)
        delete_on_termination = true
      }
    }
  }
  lifecycle {
    //ignore_changes = [image_id]
    create_before_destroy = true
  }
}
