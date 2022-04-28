variable "cluster_name" { type = string }
variable "cluster_ca" { type = string }
variable "cluster_endpoint" { type = string }
variable "eks_version" { default = "1.17" }

variable "node_role_arn" { type = string }
variable "subnets" { type = list }
variable "tags" { default = {}}
variable "node_groups" { type = map }

variable "common_ebs" { default = {} }
variable "default_root_device_name" { default = "/dev/xvda" }
variable "default_volume_type" { default = "gp3" }
variable "default_volume_size" { default = "20" }
variable "default_volume_encrypted" { default = false }
variable "default_kms_key_id" { default = "" }
variable "default_instance_type" { default = "t3.medium" }
variable "default_image_id" { default = "" }

variable "pre_userdata" { default = "" }
variable "post_userdata" { default = "" }
variable "ssh_key" { default = "" }
variable "cluster_security_group_id" {}
variable "worker_security_group_ids" { default = [] }

