 data "aws_acm_certificate" "tebedev_com"   { 
   domain   = var.host_pattern
   statuses = ["ISSUED"]
 }

locals {
  ingress_nginx = {
    name       = "ingress-nginx"
    repository = "https://nexus.tobedevops.io/repository/helm/"
    chart      = "ingress-nginx"
    namespace = "kube-system"
    chart_version = "4.7.1"
    chart_Path = "../../common/manifests/helm/nginx_ingress.yaml.tpl"
    values = {
     certificate_arn = data.aws_acm_certificate.tebedev_com.arn,
   }
  }

  metrics_server={
    name       = "metrics-server"
    repository = "https://kubernetes-sigs.github.io/metrics-server"
    chart      = "metrics-server"
    namespace = "kube-system"
    chart_version = "3.11.0"
  }

  loadbanlancer={
    name       = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    namespace = "kube-system"
    chart_version = "1.5.4"

    values_set = [
      { 
        name = "clusterName",
        value = "${var.prefix_name.Owner}-${terraform.workspace}-${local.cluster_name}"
      },
      {
        name = "serviceAccount.create",
        value = "false"
      },
      {
        name = "serviceAccount.name",
        value = "aws-load-balancer-controller"
      },
      {
        name = "enableServiceMutatorWebhook",
        value = "false"
      }
    ]


  }
  EFS={
    name       = "aws-efs-csi-driver"
    repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
    chart      = "aws-efs-csi-driver"
    namespace = "kube-system"
    chart_version = "2.4.8"

      values_set = [
        {
          name  = "image.repository",
          value = "530406784682.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-efs-csi-driver"
        },
        {
          name = "controller.serviceAccount.create",
          value = "false"
        },
        {
          name = "controller.serviceAccount.name",
          value = "amazoneks-efs-csi-driver-role"
        }
      ]
    }

   autoscaler={
    name       = "aws-cluster-autoscaler"
    repository = "https://kubernetes.github.io/autoscaler"
    chart      = "cluster-autoscaler"
    namespace = "kube-system"
    chart_version = "9.32.0"

      values_set = [
        {
          name  = "autoDiscovery.clusterName",
          value = "${var.prefix_name.Owner}-${terraform.workspace}-${local.cluster_name}"
        },
        {
          name = "awsRegion",
          value = "ap-northeast-2"
        }
      ]
    }

  EBS={
    name       = "aws-ebs-csi-driver"
    repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    chart      = "aws-ebs-csi-driver"
    namespace = "kube-system"
    chart_version = "2.20.0"

      values_set = [
        {
          name = "controller.serviceAccount.create",
          value = "false"
        },
        {
          name = "controller.serviceAccount.name",
          value = "amazoneks-ebs-csi-driver-role"
        },
        {
          name = "enableVolumeResizing",
          value = "true"
        },
        {
          name = "enableVolumeScheduling",
          value = "ture"
        }
      ]
    }
    
}


module "EBS" {
  source = "../../../modules/ETC/helm"
  name = local.EBS.name
  repository = local.EBS.repository
  chart = local.EBS.chart
  namespace = local.EBS.namespace
  chart_version = local.EBS.chart_version

  values_set = local.EBS.values_set
}

# module "EFS" {
#   source = "../../../modules/ETC/helm"
#   name = local.EFS.name
#   repository = local.EFS.repository
#   chart = local.EFS.chart
#   namespace = local.EFS.namespace
#   chart_version = local.EFS.chart_version

#   values_set = local.EFS.values_set
# }

module "autoscaler" {
  source = "../../../modules/ETC/helm"
  name = local.autoscaler.name
  repository = local.autoscaler.repository
  chart = local.autoscaler.chart
  namespace = local.autoscaler.namespace
  chart_version = local.autoscaler.chart_version

  values_set = local.autoscaler.values_set
}

module "loadbanlancer" {
  source = "../../../modules/ETC/helm"
  name = local.loadbanlancer.name
  repository = local.loadbanlancer.repository
  chart = local.loadbanlancer.chart
  namespace = local.loadbanlancer.namespace
  chart_version = local.loadbanlancer.chart_version

  values_set = local.loadbanlancer.values_set
}

# module "ingress-nginx" {
#   source = "../../../modules/ETC/helm"
#   name = local.ingress_nginx.name
#   repository = local.ingress_nginx.repository
#   chart = local.ingress_nginx.chart
#   namespace = local.ingress_nginx.namespace
#   chart_version = local.ingress_nginx.chart_version
#   chart_Path = local.ingress_nginx.chart_Path

#   values_file = local.ingress_nginx.values 
#     depends_on = [ module.loadbanlancer,
#      module.metrics-server]

# }

module "metrics-server" {
  source = "../../../modules/ETC/helm"
  name = local.metrics_server.name
  repository = local.metrics_server.repository
  chart = local.metrics_server.chart
  namespace = local.metrics_server.namespace
  chart_version = local.metrics_server.chart_version 

  depends_on = [ module.loadbanlancer ]
}
