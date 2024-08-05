locals {
  rds_name = "postgresql"
  rds_engine = "postgres"
  rds_engine_version = "14" 
  rds_port = 5432
  rds_username = "useadmin" 
  rds_password = "Tobe1234" 
  rds_parameter_group_name = "default.postgres14" 
  rds_vol_allocated_size = "20"  
  rds_vol_max_allocated_size = "1200" 
  rds_public_acces = true  

  export_data = {
    endpoint = module.postgresql.endpoint
    admin_id = local.rds_username
    password = local.rds_password
   }
}

module "postgresql" {
  source = "../../../modules/database/rds"
  name = local.rds_name
  rds_engine = local.rds_engine                  
  rds_engine_version = local.rds_engine_version 
  rds_username = local.rds_username  
  rds_password = local.rds_password  
  rds_parameter_group_name = local.rds_parameter_group_name  
  rds_vol_allocated_size = local.rds_vol_allocated_size  
  rds_vol_max_allocated_size = local.rds_vol_max_allocated_size 
  rds_inst_type = var.rds_inst_type 
  rds_port = local.rds_port
  rds_security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_db  
  rds_region = var.region_a 
  rds_subnet_ids = data.terraform_remote_state.resources.outputs.pub_subnets
  rds_public_acces = local.rds_public_acces 
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}
module "keyoutput" {
  source = "../../../modules/ETC/output_file"
  value = templatefile("${var.user_templats_path}/postgesql_readme.tpl", local.export_data)
  out_path = "${path.module}/postgressql_readme.md"
}