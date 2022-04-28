variable "project" { default = "eks-test" }
variable "env" { default = "dev" }
variable "region" { default = "us-east-2" }

variable "eks_version" { default = "1.19" }

variable "vpc_cidr" { default = "10.0.0.0/22" }
variable "vpc_azs" { default = ["us-east-2a", "us-east-2b"] }
variable "vpc_private_subnets" { default = ["10.0.0.0/24", "10.0.1.0/24"] }
variable "vpc_public_subnets" { default = ["10.0.3.0/24", "10.0.2.0/24"] }

variable "main_dns_zone" {}

#variable "" {}

locals {
  cluster_name = "${var.project}-${var.env}"

  node_groups = {
    ng_1 = {
      instance_type = "t3.medium"
      min_size      = 1
      desired_size  = 2
      max_size      = 2
      labels = {
        role = "server"
      }
    }
    ng_2 = {
      instance_type = "t3.medium"
      min_size      = 0
      desired_size  = 0
      max_size      = 3
      labels = {
        role = "agent"
      }
    }
  }

  tags = {
    Env     = "dev"
    Project = "test"
  }

  pre_userdata = "yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm"
}
