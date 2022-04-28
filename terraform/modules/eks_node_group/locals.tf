
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
  default_root_device_name = var.default_root_device_name == "" ? data.aws_ami.eks_node.root_device_name : var.default_root_device_name
}
