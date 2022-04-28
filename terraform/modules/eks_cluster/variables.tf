variable "eks_cluster_name" { type = string }
variable "eks_version" { type = string }
variable "oidc_thumbprint_list" {
  description = "A list of server certificate thumbprints for OIDC server certificates. Default is valid until: 2034-06-28T17:39:16Z"
  default     = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

variable "subnet_ids" { type = list(any) }
variable "profile" { default = "" }
variable "admin_roles" { default = [] }
variable "kubeconfig_role" { default = "" }
variable "tags" { default = {} }

variable "enabled_cluster_log_types" { default = ["api", "controllerManager", "scheduler"] }
variable "log_retention_in_days" { default = 30 }
variable "endpoint_public_access" { default = true }
variable "endpoint_private_access" { default = true }
variable "public_access_cidr" { default = "0.0.0.0/0" }
variable "create_kubeconfig" { default = false }
variable "additional_worker_policies" { default = [] }
variable "custom_aws_auth_roles" { default = [] }
