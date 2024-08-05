locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.name
  force_destroy = true
  
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}