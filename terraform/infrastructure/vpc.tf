module "vpc" {
  # module documentation: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.0
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name                 = "vpc-${local.cluster_name}"
  cidr                 = var.vpc_cidr
  azs                  = var.vpc_azs
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true
  reuse_nat_ips      = false // TODO: describe benifits of permanent EIP

  enable_vpn_gateway = false

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" : "shared",
    "kubernetes.io/role/internal-elb" : "1"
  }

  public_subnet_tags  = {
    "kubernetes.io/cluster/${local.cluster_name}" : "shared",
    "kubernetes.io/role/elb" : "1"
  }
}
