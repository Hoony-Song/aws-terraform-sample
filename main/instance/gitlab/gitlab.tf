
locals {
  
  // instance name 
  instance_name = "glab"
  root_volumes_size = 20

  //EBS_volumes
  ebs_size_GB = 100 
  ebs_device_name = "/dev/sdf"
  ebs_volume_type = "gp3"  

  user_data = {
    gitlab_host = var.gitlab_hostname
    domain = var.gitlab_domain_name
    default_password = var.default_password
   }
}

module "ec2-gitlab" {
  source             = "../../../modules/compute/ec2"
  subnet_id = data.terraform_remote_state.resources.outputs.priv_subnets[*] 
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_gitlab
  instance_type      = var.gitlab_inst_type 
  region = var.region_a
  user_data    = templatefile("${var.scripts_path}/gitlab_install.sh.tpl",local.user_data)
  name = local.instance_name 
  attached_external_IP = false 
  volume_size_GB = local.root_volumes_size
  private_ip = var.gitlab_ip                                   
  default_ami = var.default_ami   
  key_name = var.default_Key

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}

module "ebs-gitlab_sdf" {
  source             = "../../../modules/storage/ebs"
  ebs_size_GB        = local.ebs_size_GB 
  availability_zone_name = module.ec2-gitlab.availability_zone 
  instance_id      = module.ec2-gitlab.instance_id 
  name = local.instance_name
  ebs_volume_type = local.ebs_volume_type
  ebs_device_name    = local.ebs_device_name 

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag    
}