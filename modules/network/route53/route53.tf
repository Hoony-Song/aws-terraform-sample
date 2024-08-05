data "aws_route53_zone" "tobedev" {
  name = var.host_name
}

resource "aws_route53_record" "frontend_A" {
 zone_id = data.aws_route53_zone.tobedev.id
 name    = var.domain_name
 type    = var.record_type 
 alias {
    name     = var.dns_name
    zone_id  = var.zone_id 
    evaluate_target_health = true
 } 
 
}