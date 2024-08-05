output "arn"{
  value=aws_lb_target_group.lb_group.arn
}

output "instance_id"{
  value = aws_lb_target_group.lb_group.id
}