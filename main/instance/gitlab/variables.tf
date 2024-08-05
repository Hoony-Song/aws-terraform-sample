 //vpc
  //가용영역 
 variable "region_a" {}
 variable "region_c" {}
 
  variable "gitlab_hostname" {}
  variable "nexus_hostname" {}  
  variable "bastion_hostname" {}
  
  variable "gitlab_inst_type" {}
 
  //ami
  //instance에 사용 될 ami 목록 
 variable "default_ami" {}

 //Key_name
 variable "default_Key" {}

 //default password
 variable "default_password" {}

 variable "record_type" {}
 variable "host_name" {}

 variable "scripts_path" {
    description = "../common/scripts"
 }
 
 variable "ACCOUNT_ID" {}
 variable "host_pattern" {}
 variable "gitlab_domain_name" {}
 variable "gitlab_ip" {}
 
 variable "resource_tag" {}
 variable "prefix_name" {}


//port
 variable "ssh_port" {}
 variable "HTTP_port" {}
 variable "HTTPS_port" {}

//protocol 
 variable "protocol_tcp" {}
 variable "protocol_http" {}
 variable "protocol_https" {}

 //elb
 variable "target_type_inst" {}
 variable "target_type_alb" {}
 variable "load_balancer_type_net" {}
 variable "load_balancer_type_app" {}
 
 variable "backend_bucket" {}
 variable "backend_dynamodb" {}
