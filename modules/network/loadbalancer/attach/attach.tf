resource "aws_alb_target_group_attachment" "alb_attach" {
  target_group_arn = var.target_group_arn
  target_id = var.instance_id
  port = var.port
}
