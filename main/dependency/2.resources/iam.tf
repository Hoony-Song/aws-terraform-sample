

locals {
  cluster_role_name = "test-eks-cluster-role" 
  node_role_name = "test-eks-node-role"
  route53_policy_name = "external_dns"
  eks_autoscaler = "EKSAutoScaler"
  loadbalancer_policy_name = "AWSLoadBalancerControllerIAMPolicy"
  # access_key = module.smtp_user.smtp_username
  # secret_key = module.smtp_user.smtp_password
  
}

# data "aws_sns_topic" "example" {
#   name = "user-topic"
#   depends_on = [ resource.aws_sns_topic.user_updates ]
# }

/////////////////////////////////////////////////////////////////// eks cluster role
module "eks_cluster_role" {
  source       = "../../../modules/iam/Role/standard"
  name = local.cluster_role_name
  jsonPath = "../../common/jsonFile/role/eksrole.json"
  
  tags = var.resource_tag
}

module "EKSCluster_role_EKSCluster_Policy_attach" {
  source = "../../../modules/iam/attach"
  role_name = module.eks_cluster_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"    
}
module "EKSCluster_role_EKSVPCResourceController_attach" {
  source = "../../../modules/iam/attach"
  role_name = module.eks_cluster_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

/////////////////////////////////////////////////////////////////// eks node role 
module "eks_node_role" {
  source       = "../../../modules/iam/Role/standard"
  name = local.node_role_name
  jsonPath = "../../common/jsonFile/role/noderole.json"
  
  tags = var.resource_tag
}

module "autoscaler_policy" {
  source = "../../../modules/iam/policy"
  name = local.eks_autoscaler
  jsonPath = "../../common/jsonFile/policy/autoscaler.json"
  
  tags = var.resource_tag
}
                                                                        

module "EKSNode_role_EKSWorkerNodePolicy_attach" {
  source = "../../../modules/iam/attach"
  role_name = module.eks_node_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
module "EKSNode_role_EKS_CNI_Policy_attach" {
  source = "../../../modules/iam/attach"
  role_name = module.eks_node_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
module "EKSNode_role_EC2ContainerRegistryReadOnly_attach" {
  source = "../../../modules/iam/attach"
  role_name = module.eks_node_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

module "EKSNode_role_EC2AutoScaler_attach" {
  source = "../../../modules/iam/attach"
  role_name = module.eks_node_role.role_name
  policy_arn = module.autoscaler_policy.policy_arn
}

/////////////////////////////////////////////////////////////////// 
module "route53_policy" {
  source = "../../../modules/iam/policy"
  name = local.route53_policy_name
  jsonPath = "../../common/jsonFile/policy/router53.json"
  
  tags = var.resource_tag
}

module "loadbalancer_policy" {
  source = "../../../modules/iam/policy"
  name = local.loadbalancer_policy_name
  jsonPath = "../../common/jsonFile/policy/loadbalancer.json"
  
  tags = var.resource_tag
}

////////////////////////////////////////////////////////////////////

