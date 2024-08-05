

terraform {
  backend "s3" {
    key            = "main/instance/eks/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}
data "terraform_remote_state" "resources" {
  backend = "s3"
  config = {
    bucket  = var.backend_bucket
    key     = "env:/${terraform.workspace}/main/dependency/resources/terraform.tfstate"
    region  = "ap-northeast-2"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
    kubernetes = {
       source  = "hashicorp/kubernetes"
       version = "~> 2.23"

     }
     kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {  
  region = "ap-northeast-2"  
}

data "aws_eks_cluster_auth" "example" {
  name = module.eks.cluster_name
}

#  }
provider "kubernetes" {
  config_path = "~/.kube/config"
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.example.token
  exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
}

provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml" 
  repository_cache       = "${path.module}/.helm"
  kubernetes {
    config_path = "~/.kube/config"
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token = data.aws_eks_cluster_auth.example.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

provider "kubectl" {
    config_path = "~/.kube/config"
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token = data.aws_eks_cluster_auth.example.token
    # load_config_file = false
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
}

