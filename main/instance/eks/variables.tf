 
 ////////////////////////////////// common vars 
 variable "region_a" {}
 variable "region_c" {}
 variable "default_Key" {}   
 variable "ACCOUNT_ID" {}
 variable "host_pattern" {}
 variable "host_name" {} 
 
 
 ////////////////////////////////// Service Account vars 
 variable "loadbalancer_role" {}
 variable "external_dns_role" {}
 variable "ebs_csi_role" {}
 variable "efs_csi_role" {}

 variable "resource_tag" {}
 variable "prefix_name" {}



 variable "eks_inst_type" {}
 variable "user_templats_path" {
  description = "../../common/user_templats"
 }
 
 
 variable "backend_bucket" {}
 variable "backend_dynamodb" {}