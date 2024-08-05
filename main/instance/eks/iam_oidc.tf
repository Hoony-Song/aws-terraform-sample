

module "lb-oidc-role" {
  source = "../../../modules/iam/Role/template"
  jsonPath = "../../common/jsonFile/role/oidc_role.json.tpl"
  name = var.loadbalancer_role
  ACCOUNT_ID = var.ACCOUNT_ID
  OIDC_PROVIDER = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}


module "lb-oidc-role-attach" {
  source = "../../../modules/iam/attach"
  role_name = var.loadbalancer_role
  policy_arn = data.terraform_remote_state.resources.outputs.lb_policy_arn
  depends_on = [
    module.lb-oidc-role
  ]
}

module "external-oidc-role" {
  source = "../../../modules/iam/Role/template"
  jsonPath = "../../common/jsonFile/role/oidc_role.json.tpl"
  name = var.external_dns_role
  ACCOUNT_ID = var.ACCOUNT_ID
  OIDC_PROVIDER = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}


module "external-oidc-role-attach" {
  source = "../../../modules/iam/attach"
  role_name = var.external_dns_role
  policy_arn = data.terraform_remote_state.resources.outputs.external_policy_arn
  depends_on = [
    module.external-oidc-role
  ]
}

module "ebs-oidc-role" {
  source = "../../../modules/iam/Role/template"
  jsonPath = "../../common/jsonFile/role/oidc_role.json.tpl"
  name = var.ebs_csi_role
  ACCOUNT_ID = var.ACCOUNT_ID
  OIDC_PROVIDER = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}


module "ebs-oidc-role-attach" {
  source = "../../../modules/iam/attach"
  role_name = var.ebs_csi_role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  depends_on = [
    module.ebs-oidc-role
  ]
}

module "efs-oidc-role" {
  source = "../../../modules/iam/Role/template"
  jsonPath = "../../common/jsonFile/role/oidc_role.json.tpl"
  name = var.efs_csi_role
  ACCOUNT_ID = var.ACCOUNT_ID
  OIDC_PROVIDER = replace(module.eks.cluster_oidc_issuer_url, "https://", "")

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag          
}

module "efs-oidc-role-attach" {
  source = "../../../modules/iam/attach"
  role_name = var.efs_csi_role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  depends_on = [
    module.efs-oidc-role
  ]
}