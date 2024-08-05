resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = var.listener_arn
  priority = var.priority
  action {
    type = var.rule_type

    redirect {
      port        = var.redirect_port
      protocol    = var.redirect_protocol
      status_code = var.redirect_state_code
    }
  }

  condition {
    host_header {
      values = ["${var.redirect_pattern_path}"]
    }
  }
  tags = {
    Name = var.name
  }
}