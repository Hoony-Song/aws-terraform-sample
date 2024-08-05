locals {
  serviceaccount = {
    IAM_SA={
      "loadbalancer" = {
          name = "${var.loadbalancer_role}"
          namespace = "kube-system"
          role_arn = "arn:aws:iam::${var.ACCOUNT_ID}:role/${var.loadbalancer_role}"
          managed = "terraform"
      },
      "dns" = {
          name = "${var.external_dns_role}"
          namespace = "kube-system"
          role_arn = "arn:aws:iam::${var.ACCOUNT_ID}:role/${var.external_dns_role}"
          managed = "terraform"
      },
      "ebs" = {
          name = "${var.ebs_csi_role}"
          namespace = "kube-system"
          role_arn = "arn:aws:iam::${var.ACCOUNT_ID}:role/${var.ebs_csi_role}"
          managed = "terraform"
      },
      "efs" = {
          name = "${var.efs_csi_role}"
          namespace = "kube-system"
          role_arn = "arn:aws:iam::${var.ACCOUNT_ID}:role/${var.efs_csi_role}"
          managed = "terraform"
      }
    }
  }  
}


module "serviceaccount" {
  source = "../../../modules/compute/eks/serviceaccount"
  for_each = local.serviceaccount.IAM_SA
  name = each.value.name
  namespace = each.value.namespace
  role_arn = each.value.role_arn
  labels_managed = each.value.managed
}