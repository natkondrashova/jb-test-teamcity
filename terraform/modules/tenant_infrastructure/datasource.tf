# https://www.terraform.io/language/state/remote-state-data
data "terraform_remote_state" "main_infrastructure" {
  backend = var.remote_state_type
  config  = local.remote_state_config
}
