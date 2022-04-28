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
