data "aws_acm_certificate" "tebedev_com" { 
   domain   = var.host_pattern
   statuses = ["ISSUED"]
 }

resource "aws_alb_listener" "ssl_listener" {
  count             = var.ssl_attach ? 1 : 0
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy      = var.ssl_policy
  certificate_arn = data.aws_acm_certificate.tebedev_com.arn

  default_action {
    target_group_arn = var.target_group_arn
    type             = var.target_type
  }  
}

resource "aws_alb_listener" "listener" {
  count             = var.ssl_attach ? 0 : 1
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    target_group_arn = var.target_group_arn
    type             = var.target_type
  }  
}
