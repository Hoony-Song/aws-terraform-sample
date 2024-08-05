locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
data "aws_eks_cluster_auth" "example" {
  name = aws_eks_cluster.terraform-eks-cluster.name
}
resource "aws_eks_cluster" "terraform-eks-cluster" {
  name = "${var.prefix_name}-${terraform.workspace}-${var.cluster_name}"
  role_arn = "${var.cluster_role_arn}"
  version = var.kube_version
  

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  
  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = var.private_subnets[*].id 
    endpoint_private_access = true
    endpoint_public_access = true
  }

  tags = merge(local.resource_tag,{
    Name = var.cluster_name
  })
}

# 마지막으로 Node Group을 생성한다.
resource "aws_eks_node_group" "terraform-eks-linux" {
  
  cluster_name    = aws_eks_cluster.terraform-eks-cluster.name
  node_group_name = "${var.prefix_name}-${terraform.workspace}-${var.node_group_name}"
  node_role_arn   = "${var.node_role_arn}"
  subnet_ids      = var.private_subnets[*].id
  instance_types = var.eks_inst_type
  capacity_type = var.capacity_type


  labels = {
    "role" = "${var.prefix_name}-${terraform.workspace}-${var.node_group_name}"
  }

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  
  launch_template {
    id      = aws_launch_template.eks-linux.id
    version = var.LT_version
  }
  
  tags = merge(local.resource_tag,{
    Name = var.node_group_name
  })
}

resource "aws_eks_addon" "example" {
  cluster_name = aws_eks_cluster.terraform-eks-cluster.name
  addon_name   = "vpc-cni"  
}



data "tls_certificate" "example" {
  url = aws_eks_cluster.terraform-eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "example" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.terraform-eks-cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "example_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.example.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "example" {
  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json
  name               = "example-vpc-cni-role"
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example.name
}



resource "aws_launch_template" "eks-linux" {
  name                 = "${var.prefix_name}-${terraform.workspace}-${var.node_name}"
   block_device_mappings {
    device_name = "/dev/xvda" #xvda
    
    ebs {
      volume_size = var.root_volumes_size
    }
    
  }
  key_name = var.key_name
  
tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "${var.prefix_name}-${terraform.workspace}-${var.node_name}"
    }
  }

  metadata_options {
    http_put_response_hop_limit = 3
  }

  
}
