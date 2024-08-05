locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_lb_target_group" "lb_group" {
    name    = "${var.prefix_name}-${terraform.workspace}-${var.name}"
    target_type = var.target_type
    port     = var.port
    protocol = var.protocol
    vpc_id   = var.vpc_id

    health_check {
    //enabled             = true
    healthy_threshold   = 3
    interval            = 30
    unhealthy_threshold = 3
    //matcher             = "200" 
    path                = "/"
    //port                = "traffic-port"
    //protocol            = "HTTP"
  }
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}
