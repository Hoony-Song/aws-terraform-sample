locals {
    // instance name 
  instance_name = "nexus" 
  root_volumes_size = 20

 
  // domain name

  // ebs volumes
  ebs_size_GB = 200
  ebs_device_name = "/dev/sdh"
  ebs_volume_type = "gp3"
  user_data = {
    nexus_host = var.nexus_hostname
   }
}

# EC2 default
module "ec2-nexus" {
  source             = "../../../modules/compute/ec2"
  subnet_id = data.terraform_remote_state.resources.outputs.priv_subnets[*] 
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_nexus
  instance_type      = var.nexus_inst_type 
  region = var.region_c 
  user_data    = templatefile("${var.scripts_path}/nexus_install.sh.tpl",local.user_data)
  private_ip = var.nexus_ip
  name = local.instance_name 
  attached_external_IP = false 
  volume_size_GB = local.root_volumes_size                            
  default_ami = var.default_ami   
  key_name = var.default_Key 
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}

module "ebs-nexus_sdh" {
  source             = "../../../modules/storage/ebs"
  ebs_size_GB        = local.ebs_size_GB    
  availability_zone_name = module.ec2-nexus.availability_zone 
  instance_id      = module.ec2-nexus.instance_id
  name = local.instance_name
  ebs_volume_type = local.ebs_volume_type
  ebs_device_name    = local.ebs_device_name 
  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}