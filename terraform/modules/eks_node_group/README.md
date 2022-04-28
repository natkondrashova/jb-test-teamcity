# eks_node_group

## Inputs
### Required variables

| Name  | Description   | Type   |
|---|---|---|
| cluster_name  | name of the cluster  | string  |
| cluster_ca  | cluster ca  | string   |
| cluster_endpoint   | cluster endpoint  | string  |
| node_role_arn   | arn of worker role  | string  |
| subnets   | list of subnet ids for worker instances  | list  |
| node_groups   | map of node groups.`Find more information below*`   | map  |
| cluster_security_group_id   | sg id that allow worker instances to communicate with control plane  | string  |
| tags   | map of tags   | map  |

### Optional variables

| Name  | Description   | Type   | Default     |
|---|---|---|---|
| eks_version   | version of eks cluster  | string  | `1.17` |
| node_groups   | map of node groups  | map  | `{}` |
| common_ebs | ebs volumes which are common to all node groups (does not include root ebs, which is always created) | map | `{}` |
| worker_security_group_ids   | list of sg ids that allow remote access to the workers  | list  | []   |
| ssh_key | ssh key to copy to node group instances | string | `""` |
| default_root_device_name | name of root device. The parameter can be overridden at the node group level by passing the key `root_device_name` in the node_groups variable | string | `/dev/xvda` |
| default_volume_type | The parameter can be overridden by `common_ebs[name]["volume_type"]` and `node_groups[name][additional_ebs][volume_type]`. | string | `gp2` |
| default_volume_size | The parameter can be overridden by `common_ebs[name]["volume_size"]` and `node_groups[name][additional_ebs][volume_size]`. | string | `20` |
| default_instance_type | type of instance. The parameter can be overridden at the node group level by `node_groups[name]["instance_type"]` | string | `t3.medium` |
| default_image_id | image id. The parameter can be overridden at the node group level by `node_groups[name]["image_id"]` | string | `see the section: default_image_id` |
| pre_userdata | additional userdata | string | `""` |
| post_userdata | additional userdata | string | `""` |

#### extension
1. default_image_id. If default_image_id is `""`, then the value will be overridden: aws eks ami with a suitable version (=eks_version) will be used:
```buildoutcfg
data "aws_ami" "eks_node" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}*"]
  }
}

locals {
  default_image_id         = var.default_image_id == "" ? data.aws_ami.eks_node.id : var.default_image_id
}
```

### Node groups
#### Example

```buildoutcfg
  node_groups = {
    test = {
      instance_type   = "m5.large"
      image_id        = data.aws_ami.eks_node.id
      min_size        = 1
      desired_size    = 2
      max_size        = 3
    },
  }
```
