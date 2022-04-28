terraform {
  required_version = "= v1.1.8"
  required_providers {
    aws        = ">= 3.63.0"
    local      = ">= 1.4"
    null       = ">= 2.1"
    template   = ">= 2.1"
    random     = ">= 2.1"
    kubernetes = "~> 1.13.3"
  }
}

provider "aws" {
  region  = var.region

  default_tags {
    tags = {
      "Project" = "test"
      "Env"     = "lab"
    }
  }
}

#provider kubernetes {
#  load_config_file = false
#
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
#  host                   = data.aws_eks_cluster.this.endpoint
#  token                  = data.aws_eks_cluster_auth.this.token
#}
#
#data aws_eks_cluster_auth this {
#  name = module.eks_cluster.cluster_name
#}
#
#data aws_eks_cluster this {
#  name = module.eks_cluster.cluster_name
#}
