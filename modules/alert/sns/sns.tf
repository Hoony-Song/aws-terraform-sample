
provider "aws" {
  alias  = "dokyo"
  region = "ap-northeast-1"
}

resource "aws_sns_topic" "sns" {
  name            = var.name
  delivery_policy = file("${var.delivery_policy}") 
  tags = var.tags  
  provider = aws.dokyo
  policy = var.policy
}