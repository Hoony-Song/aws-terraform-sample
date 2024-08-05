 //vpc
  //가용영역 
 variable "region_a" {}
 variable "region_c" {}

  //instance hostname  
  variable "gitlab_hostname" {}
  variable "nexus_hostname" {}  
  variable "bastion_hostname" {}


  variable "bastion_inst_type" {}
 

  //ami
 variable "default_ami" {}
 
 //default password
 variable "default_password" {}

 //Key_name
 variable "default_Key" {}

 // private ip
 variable "bastion_ip" {}

 variable "scripts_path" {
  description = "../../common/scripts"
 }
 variable "user_templats_path" {
  description = "../../common/user_templats"
 }

 
 variable "gitlab_ip" {}
 variable "nexus_ip" {}  

 variable "resource_tag" {}
 variable "prefix_name" {}
 
 variable "backend_bucket" {}
 variable "backend_dynamodb" {}