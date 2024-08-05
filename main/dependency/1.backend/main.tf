
 variable "backend_bucket" {}
 variable "backend_dynamodb" {}
provider "aws" {
  region = "ap-northeast-2"
  version = "~> 5.8.0"

  default_tags {
  tags = {
    Type = "install"
    Project = "nexacro-deploy"
    Owner = "tobesoft"
  }
}
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.backend_bucket
  force_destroy = true
  
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = var.backend_dynamodb
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    key            = "main/dependency/backend/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}
