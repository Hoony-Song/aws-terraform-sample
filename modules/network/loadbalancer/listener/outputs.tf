output "listener_arn" {
  value = var.ssl_attach ? aws_alb_listener.ssl_listener[0].arn : aws_alb_listener.listener[0].arn
}
