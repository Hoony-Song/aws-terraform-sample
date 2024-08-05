 //vpc
  //가용영역 
 variable "region_a" {}
 variable "region_c" {}
 
  //ami
  //instance에 사용 될 ami 목록 
 variable "default_ami" {}

 //Key_name
 variable "default_Key" {}


  variable "gitlab_hostname" {}
  variable "nexus_hostname" {}  
  variable "bastion_hostname" {}

  
  variable "nexus_inst_type" {}

 variable "record_type" {}
 variable "host_name" {}

 variable "scripts_path" {
    description = "../common/scripts"
 }
 
 variable "ACCOUNT_ID" {}
 variable "host_pattern" {}
 variable "nexus_domain_name" {}
 variable "reg_domain_name" {}
 variable "nexus_ip" {}

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