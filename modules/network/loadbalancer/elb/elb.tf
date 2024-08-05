locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_lb" "lb" {
  name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  internal = false
  load_balancer_type = var.load_balancer_type
  security_groups = ["${var.security_group_id}"]
  subnets = var.public_subnets[*].id
  
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
  enable_cross_zone_load_balancing = true

  lifecycle {
    create_before_destroy = true
  }
}
