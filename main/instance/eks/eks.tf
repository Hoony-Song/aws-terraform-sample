
locals {  
  kube_version = "1.27"
  desired_size = 2
  min_size = 1
  max_size = 5
  root_volumes_size = 20
  cluster_name = "cluster"
  capacity_type = "SPOT"

  custom_tag = merge(var.resource_tag, { 
    "k8s.io/cluster-autoscaler/enabled" = ""
    "k8s.io/cluster-autoscaler/${var.prefix_name.Owner}-${terraform.workspace}-${local.cluster_name}" = ""
   })
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "${var.prefix_name.Owner}-${terraform.workspace}-${local.cluster_name}"
  cluster_version                 = local.kube_version 
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts_on_create  = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts_on_create  = "OVERWRITE"
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }
  
  create_iam_role = false
  iam_role_arn = data.terraform_remote_state.resources.outputs.cluster_role_arn

#   cluster_encryption_config = [{
#     provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
#     resources        = ["secrets"]
#   }]

  vpc_id     = data.terraform_remote_state.resources.outputs.vpc_id
  # subnet_ids = [data.terraform_remote_state.resources.outputs.priv_subnets[var.region_a].id,data.terraform_remote_state.resources.outputs.priv_subnets[var.region_c].id]
  subnet_ids = data.terraform_remote_state.resources.outputs.priv_subnets[*].id
  # Self Managed Node Group(s)
#   self_managed_node_group_defaults = {
#     instance_type                          = "m6i.large"
#     update_launch_template_default_version = true
#     iam_role_additional_policies           = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
#   }
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2023_x86_64_STANDARD"
    disk_size              = local.root_volumes_size
    instance_types         = ["t3a.large"]
    vpc_security_group_ids = [data.terraform_remote_state.resources.outputs.security_group_id_all]
  }
   enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {    
    # extend_config = {
    #   # This is supplied to the AWS EKS Optimized AMI
    #   # bootstrap script https://github.com/awslabs/amazon-eks-ami/blob/master/files/bootstrap.sh
    #   bootstrap_extra_args = "--container-runtime containerd --kubelet-extra-args '--max-pods=110'"

    #   # This user data will be injected prior to the user data provided by the
    #   # AWS EKS Managed Node Group service (contains the actually bootstrap configuration)
    #   pre_bootstrap_user_data = <<-EOT
    #     export CONTAINER_RUNTIME="containerd"
    #     export USE_MAX_PODS=false
    #   EOT
    # }
    # blue = {
    #   capacity_type  = "SPOT"
    # }
    default = {
      #node_group_name="nametest"
      create_iam_role = false
      iam_role_arn = data.terraform_remote_state.resources.outputs.node_role_arn
      min_size     = local.min_size
      max_size     = local.max_size
      desired_size = local.desired_size
      disk_size = local.root_volumes_size
      pre_bootstrap_user_data = <<-EOT
        #!/bin/bash
        LINE_NUMBER=$(grep -n "KUBELET_EXTRA_ARGS=\$2" /etc/eks/bootstrap.sh | cut -f1 -d:)
        REPLACEMENT="\ \ \ \ \ \ KUBELET_EXTRA_ARGS=\$(echo \$2 | sed -s -E 's/--max-pods=[0-9]+/--max-pods=100/g')"
        sed -i '/KUBELET_EXTRA_ARGS=\$2/d' /etc/eks/bootstrap.sh
        sed -i "$${LINE_NUMBER}i $${REPLACEMENT}" /etc/eks/bootstrap.sh
      EOT
      instance_types = ["t3a.large"]
      capacity_type  = local.capacity_type
      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
    #   taints = {
    #     dedicated = {
    #       key    = "dedicated"
    #       value  = "gpuGroup"
    #       effect = "NO_SCHEDULE"
    #     }
    #   }
      tags = {
        ExtraTag = "example"
      }
    }
  }


  tags = local.custom_tag
}


module "keyoutput" {
  source = "../../../modules/ETC/output_file"
  value = templatefile("${var.user_templats_path}/eks_readme.tpl", { value = module.eks.cluster_name })
  tpl_path = "../../common/user_templats/eks_readme.tpl"
  out_path = "${path.module}/eks_readme.md"  
}
