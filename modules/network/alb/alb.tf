locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_alb" "alb" {
  name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  internal = false
  load_balancer_type = "application"
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

resource "aws_alb_target_group" "alb_group" {
    name    = "${var.prefix_name}-${terraform.workspace}-${var.name}"
    port     = 80
    protocol = "HTTP"
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
 data "aws_acm_certificate" "tebedev_com"   { 
   domain   = var.host_pattern
   statuses = ["ISSUED"]
 }

resource "aws_alb_listener" "HTTPS" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "${data.aws_acm_certificate.tebedev_com.arn}"
  default_action {
    target_group_arn = "${aws_alb_target_group.alb_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "alb_attach" {
  target_group_arn = aws_alb_target_group.alb_group.arn
  target_id = "${var.instance_id}"
  port = 80
}
