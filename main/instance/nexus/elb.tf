
locals {
  nexus_alb_name = "alb-nexus"
  nexus_inst_tg_name = "tg-inst-nexus"
  reg_alb_name = "alb-reg"
  reg_inst_tg_name = "tg-inst-reg"
  nexus_port = 8081 
  reg_port = 5000
}

module "alb-nexus" {
  source             = "../../../modules/network/loadbalancer/elb"
  name = local.nexus_alb_name
  load_balancer_type = var.load_balancer_type_app
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_all
  public_subnets = data.terraform_remote_state.resources.outputs.pub_subnets  
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}

module "tg-nexus" {
  source             = "../../../modules/network/loadbalancer/targetgroup"
  name = local.nexus_inst_tg_name
  target_type = var.target_type_inst
  port = var.HTTP_port
  vpc_id = data.terraform_remote_state.resources.outputs.vpc_id
  protocol =  var.protocol_http
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag             
}

module "listener-alb-https"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTPS_port
  protocol = var.protocol_https
  ssl_attach = true
  target_group_arn = module.tg-nexus.arn
  load_balancer_arn = module.alb-nexus.arn
  host_pattern = var.host_pattern
  
  depends_on = [ module.tg-nexus ]
}

module "listener-alb-http"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTP_port
  protocol = var.protocol_http
  ssl_attach = false
  target_group_arn = module.tg-nexus.arn
  load_balancer_arn = module.alb-nexus.arn
  host_pattern = var.host_pattern
  
  depends_on = [ module.tg-nexus ]
}

module "listener_rule" {
  source = "../../../modules/network/loadbalancer/listener_rule"
  listener_arn = module.listener-alb-http.listener_arn
  redirect_port = var.HTTPS_port
  redirect_protocol = var.protocol_https
  redirect_pattern_path = var.host_pattern
  priority = "10"  
  
  depends_on = [ module.tg-nexus ]
}

module "nexus-http-attach" {
  source             = "../../../modules/network/loadbalancer/attach"
  target_group_arn = module.tg-nexus.arn
  instance_id =  module.ec2-nexus.instance_id
  port = var.HTTP_port  
  
  depends_on = [ module.tg-nexus ]
  
}
module "nexus-attach" {
  source             = "../../../modules/network/loadbalancer/attach"
  target_group_arn = module.tg-nexus.arn
  instance_id =  module.ec2-nexus.instance_id
  port = local.nexus_port  
  
  depends_on = [ module.tg-nexus ]
}

module "nexus_route" {
  source       = "../../../modules/network/route53"
  zone_id = module.alb-nexus.alb_zone_id
  dns_name = module.alb-nexus.alb_dns_name
  domain_name = var.nexus_domain_name
  host_name = var.host_name
  record_type = var.record_type
}


module "alb-reg" {
  source             = "../../../modules/network/loadbalancer/elb"
  name = local.reg_alb_name
  load_balancer_type = var.load_balancer_type_app
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_all
  public_subnets = data.terraform_remote_state.resources.outputs.pub_subnets  
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}

module "tg-reg" {
  source             = "../../../modules/network/loadbalancer/targetgroup"
  name = local.reg_inst_tg_name
  target_type = var.target_type_inst
  port = local.reg_port
  vpc_id = data.terraform_remote_state.resources.outputs.vpc_id
  protocol =  var.protocol_http
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}

module "reg-listener-alb-https"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTPS_port
  protocol = var.protocol_https
  ssl_attach = true
  target_group_arn = module.tg-reg.arn
  load_balancer_arn = module.alb-reg.arn
  host_pattern = var.host_pattern
  depends_on = [ module.tg-reg ]
}
module "reg-http-attach" {
  source             = "../../../modules/network/loadbalancer/attach"
  target_group_arn = module.tg-reg.arn
  instance_id =  module.ec2-nexus.instance_id
  port = local.reg_port  
  depends_on = [ module.tg-reg ]
}
module "reg_route" {
  source       = "../../../modules/network/route53"
  zone_id = module.alb-reg.alb_zone_id
  dns_name = module.alb-reg.alb_dns_name
  domain_name = var.reg_domain_name
  host_name = var.host_name
  record_type = var.record_type
}



