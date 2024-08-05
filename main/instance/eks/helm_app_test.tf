locals {
    rabbitmq = {
    name       = "rabbitmq"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "rabbitmq"
    namespace = "rabbitmq"
    chart_version = "12.0.4"
    chart_Path = "../../common/manifests/helm/rabbitmq.yaml.tpl"
    values = {
    certificate_arn = data.aws_acm_certificate.tebedev_com.arn,
    domain = "rabbit.hoony.shop",
    }
  }

  argocd = {
    name       = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    namespace = "argocd"
    chart_version = "5.37.0"
    chart_Path = "../../common/manifests/helm/argocd.yaml.tpl"
    values = {
    certificate_arn = data.aws_acm_certificate.tebedev_com.arn,
    domain = "argocd.hoony.shop",
    }
  }
  # velero = {
  #   name       = "velero"
  #   repository = "https://vmware-tanzu.github.io/helm-charts/"
  #   chart      = "velero"
  #   namespace = "velero"
  #   chart_version = "5.0.2"
  #   chart_Path = "../../common/manifests/helm/velero.yaml.tpl"
  #   values = {
  #   velero_bucketname = var.s3_bucket_velero,
  #   workspace = "${terraform.workspace}",
  #   access_key = var.access_key,
  #   secret_key = var.secret_key
  #   }
  # }  
}


# module "rabbitmq" {
#   source = "../../../modules/ETC/helm"
#   name = local.rabbitmq.name
#   repository = local.rabbitmq.repository
#   chart = local.rabbitmq.chart
#   namespace = local.rabbitmq.namespace
#   chart_version = local.rabbitmq.chart_version
#   chart_Path = local.rabbitmq.chart_Path
#   values_file = local.rabbitmq.values
# }

# module "argocd" {
#   source = "../../../modules/ETC/helm"
#   name = local.argocd.name
#   repository = local.argocd.repository
#   chart = local.argocd.chart
#   namespace = local.argocd.namespace
#   chart_version = local.argocd.chart_version
#   chart_Path = local.argocd.chart_Path
#   values_file = local.argocd.values
# }