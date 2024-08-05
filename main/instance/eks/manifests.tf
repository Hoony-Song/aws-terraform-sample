
data "aws_route53_zone" "zone" {
  name = var.host_name
}

module "kube_manifest" {
  source = "../../../modules/ETC/kube"
  manifests_Path = "../../common/manifests/kube"
  
}

locals {
  external_dns ={
    values = {
      ACCOUNT_ID = var.ACCOUNT_ID
      host_name = var.host_name
      host_zone = data.aws_route53_zone.zone.id
   }   
  }
  efs_sc ={
    values = {
      efs_id = data.terraform_remote_state.resources.outputs.EFS_id
   }   
  }
}

module "external_dns_manifest" {
    source = "../../../modules/ETC/kube_tpl"
    manifests_Path = "../../common/manifests/kube_tpl/external_dns.yaml.tpl"  
    yaml_var = local.external_dns.values  
}

module "efs_storageclass" {
    source = "../../../modules/ETC/kube_tpl"
    manifests_Path = "../../common/manifests/kube_tpl/efs.yaml.tpl"
    yaml_var = local.efs_sc.values  
}
