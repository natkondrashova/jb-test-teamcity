variable "tenant_name" {}

variable "region" { default = "us-west-2" }
variable "main_dns_zone" { default = "" }
variable "security_group_id" { default = "" }
variable "mysql_subnet_group" { default = "" }
variable "cluster_name" { default = "" }
variable "oidc_provider_arn" { default = "" }

variable "remote_state_type" { default = "local" }
variable "remote_state_config" { default = {} }

variable "cloudfront_whitelist" {
  default = ["TR"]
}

variable "cloudwatch_retention_in_days" {
  default = 7
}

locals {
  region             = var.region != "" ? var.region : data.terraform_remote_state.main_infrastructure.outputs.region
  main_dns_zone      = var.main_dns_zone != "" ? var.main_dns_zone : data.terraform_remote_state.main_infrastructure.outputs.main_dns_zone
  security_group_id  = var.security_group_id != "" ? var.security_group_id : data.terraform_remote_state.main_infrastructure.outputs.security_group_id
  mysql_subnet_group = var.mysql_subnet_group != "" ? var.mysql_subnet_group : data.terraform_remote_state.main_infrastructure.outputs.mysql_subnet_group
  cluster_name       = var.cluster_name != "" ? var.cluster_name : data.terraform_remote_state.main_infrastructure.outputs.cluster_name
  oidc_provider_arn  = var.oidc_provider_arn != "" ? var.oidc_provider_arn : data.terraform_remote_state.main_infrastructure.outputs.oidc_provider_arn

  remote_state_config = var.remote_state_type == "local" ? { path = "${path.module}/../../infrastructure/terraform.tfstate" } : var.remote_state_config
}
