locals{
  efs_name = "efs" 
  velero_bucket_name = "velero-backup-bucket2"
}

module "efs" {
  source = "../../../modules/storage/efs"
  name = local.efs_name
  private_subnets = module.vpc.private_subnets
  security_group_id = module.sg_all.security_group_id
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}

# module "s3_bucket_velero" {
#   source = "../../../modules/storage/S3"
#   name = local.velero_bucket_name  
  
#   prefix_name = var.prefix_name.Owner
#   tags = var.resource_tag
# }