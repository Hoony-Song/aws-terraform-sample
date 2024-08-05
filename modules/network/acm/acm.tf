locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_acm_certificate" "acm" {
    domain_name       = var.host_pattern
    validation_method = "DNS"
    tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
  
  lifecycle {
    create_before_destroy = false
  }
}


