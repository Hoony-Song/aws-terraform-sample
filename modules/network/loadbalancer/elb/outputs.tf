output "alb_dns_name" {
  value = aws_lb.lb.dns_name
}
output "alb_zone_id" {
  value = aws_lb.lb.zone_id
}

output "arn"{
  value=aws_lb.lb.arn
}
output "instance_id"{
  value=aws_lb.lb.id
}