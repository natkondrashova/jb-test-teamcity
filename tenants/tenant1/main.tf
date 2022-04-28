variable "region" {}

module "tenant1" {
  source            = "../../terraform/modules/tenant_infrastructure"
  tenant_name       = "test1"
  remote_state_type = "local"

  ## In real projects we have to use something like S3 with versioning, locks etc
  #  remote_state_type = "s3"
  #  remote_state_config = {
  #    bucket = "my-bucket-name"
  #    key = "my-key-name"
  #    region = "my-region"
  #  }
}

# We need this to get parameters for helm
output "tenant_output" {
  value     = module.tenant1
  sensitive = true
}
