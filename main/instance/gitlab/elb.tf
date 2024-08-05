

locals {
  gitlab_alb_name = "alb-gitlab"
  gitlab_inst_tg_name = "tg-inst-gitlab"
  gitlab_nlb_name = "gitlab-nlb"
  gitlab_alb_tg_name = "tg-alb-gitlab"
  gitlab_ssh_inst_tg_name = "tg-gitlab-ssh"
}

 module "alb-gitlab" {
  source             = "../../../modules/network/loadbalancer/elb"
  name = local.gitlab_alb_name
  load_balancer_type = var.load_balancer_type_app
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_all
  public_subnets = data.terraform_remote_state.resources.outputs.pub_subnets  

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}

module "tg-gitlab" {
  source             = "../../../modules/network/loadbalancer/targetgroup"
  name = local.gitlab_inst_tg_name
  target_type = var.target_type_inst
  port = var.HTTP_port
  vpc_id = data.terraform_remote_state.resources.outputs.vpc_id
  protocol =  var.protocol_http

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}

module "listener-alb-http"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTP_port
  protocol = var.protocol_http
  ssl_attach = false
  target_group_arn = module.tg-gitlab.arn
  load_balancer_arn = module.alb-gitlab.arn  
  host_pattern = var.host_pattern
  depends_on = [
    module.tg-gitlab,
    module.alb-gitlab
  ]
}

module "listener_rule" {
  source = "../../../modules/network/loadbalancer/listener_rule"
  listener_arn = module.listener-alb-http.listener_arn
  redirect_port = var.HTTPS_port
  redirect_protocol = var.protocol_https
  redirect_pattern_path = var.host_pattern
  priority = "1"  
}
module "listener-alb-https"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTPS_port
  protocol = var.protocol_https
  ssl_attach = true
  target_group_arn = module.tg-gitlab.arn
  load_balancer_arn = module.alb-gitlab.arn  
  host_pattern = var.host_pattern
  depends_on = [
    module.tg-gitlab,
    module.alb-gitlab
  ]
}


module "gitlab-http-attach" {
  source             = "../../../modules/network/loadbalancer/attach"
  target_group_arn = module.tg-gitlab.arn
  instance_id =  module.ec2-gitlab.instance_id
  port = var.HTTP_port
}

module "tg-gitlab-alb" {
  source             = "../../../modules/network/loadbalancer/targetgroup"
  name = local.gitlab_alb_tg_name
  target_type = var.target_type_alb
  port = var.HTTPS_port
  vpc_id = data.terraform_remote_state.resources.outputs.vpc_id
  protocol =  var.protocol_tcp
  depends_on = [
    module.listener-alb-https
  ]

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}

module "gitlab-alb-attach2" {
  source             = "../../../modules/network/loadbalancer/attach"
  target_group_arn = module.tg-gitlab-alb.arn
  instance_id =  module.alb-gitlab.arn
  port = var.HTTPS_port 
}

 module "gitlab-nlb" {
  source             = "../../../modules/network/loadbalancer/elb"
  name = local.gitlab_nlb_name
  load_balancer_type = var.load_balancer_type_net
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_all
  public_subnets = data.terraform_remote_state.resources.outputs.pub_subnets

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}

module "listener-nlb-https"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTPS_port
  protocol = var.protocol_tcp
  target_group_arn = module.tg-gitlab-alb.arn
  load_balancer_arn = module.gitlab-nlb.arn
  host_pattern = var.host_pattern
  depends_on = [
    module.tg-gitlab,
    module.alb-gitlab,
    # module.listener-alb-https
  ]
}

module "listener-nlb-http"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.HTTP_port
  protocol = var.protocol_tcp
  target_group_arn = module.tg-gitlab-alb.arn
  load_balancer_arn = module.gitlab-nlb.arn
  host_pattern = var.host_pattern
  depends_on = [
    module.tg-gitlab,
    module.alb-gitlab,    
    # module.listener-alb-http
  ]
}

module "tg-gitlab-ssh" {
  source             = "../../../modules/network/loadbalancer/targetgroup"
  name = local.gitlab_ssh_inst_tg_name
  target_type = var.target_type_inst
  port = var.ssh_port
  vpc_id = data.terraform_remote_state.resources.outputs.vpc_id
  protocol =  var.protocol_tcp

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}

module "listener-nlb-ssh"{
  source             = "../../../modules/network/loadbalancer/listener"
  port = var.ssh_port
  protocol = var.protocol_tcp
  target_group_arn = module.tg-gitlab-ssh.arn
  load_balancer_arn = module.gitlab-nlb.arn
  host_pattern = var.host_pattern  
}

module "gitlab-ec2-attach-ssh" {
  source             = "../../../modules/network/loadbalancer/attach"
  target_group_arn = module.tg-gitlab-ssh.arn
  instance_id =  module.ec2-gitlab.instance_id
  port = var.ssh_port  ////// http
}

module "gitlab_route" {
  source       = "../../../modules/network/route53"
  zone_id = module.gitlab-nlb.alb_zone_id
  dns_name = module.gitlab-nlb.alb_dns_name
  domain_name = var.gitlab_domain_name
  host_name = var.host_name
  record_type = var.record_type
}
