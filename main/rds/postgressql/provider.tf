
terraform {
  backend "s3" {
    key            = "main/rds/postgressql/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}

data "terraform_remote_state" "resources" {
  backend = "s3"
  config = {
    bucket  = var.backend_bucket
    key     = "env:/${terraform.workspace}/main/dependency/resources/terraform.tfstate"
    region  = "ap-northeast-2"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

#AWS 리전 
provider "aws" {
  region = "ap-northeast-2"  
}
