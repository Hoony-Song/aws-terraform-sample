locals {
   // instance name 
  instance_name = "bastion" 
  
  // root volume
  root_disk_size = 20

  user_data = {
    bastion_host = var.bastion_hostname
    gitlab_ip = var.gitlab_ip
    nexus_ip = var.nexus_ip
    nexus_host = var.nexus_hostname
    gitlab_host = var.gitlab_hostname
   }

   export_data = {
    remote_addr = module.ec2.public_eip
    pem_keyname = var.default_Key
    nexus_host = var.nexus_hostname
    gitlab_host = var.gitlab_hostname
   }
}


module "ec2" {
  source             = "../../../modules/compute/ec2"
  subnet_id = data.terraform_remote_state.resources.outputs.pub_subnets[*]
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_bastion
  instance_type      = var.bastion_inst_type
  user_data    = templatefile("${var.scripts_path}/bastion.sh.tpl",local.user_data)
  region = var.region_a                             
  private_ip = var.bastion_ip
  name = local.instance_name                                      
  attached_external_IP = true                                       
  volume_size_GB = local.root_disk_size                                              
  default_ami = var.default_ami                                      
  key_name = var.default_Key

  
  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag                                 
}

module "keyoutput" {
  source = "../../../modules/ETC/output_file"
  value = templatefile("${var.user_templats_path}/bastion_readme.tpl", local.export_data)
  out_path = "${path.module}/bastion_readme.md"
}