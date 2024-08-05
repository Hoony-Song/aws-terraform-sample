
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

terraform {
  backend "s3" {
    key            = "main/dependency/resources/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}

data "aws_iam_policy_document" "ses_sender" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}