

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "pub_subnets" {
  value = module.vpc.pub_subnets[*]
}

output "priv_subnets" {
  value = module.vpc.private_subnets[*]
}

output "security_group_id_all" {
  value = module.sg_all.security_group_id
}
output "security_group_id_bastion" {
  value = module.sg_bastion.security_group_id
}
output "security_group_id_gitlab" {
  value = module.sg_gitlab.security_group_id
}
output "security_group_id_nexus" {
  value = module.sg_nexus.security_group_id
}
output "security_group_id_db" {
  value = module.sg_db.security_group_id
}

output "cluster_role_arn" {
  value = module.eks_cluster_role.role_arn
}
output "node_role_arn" {
  value = module.eks_node_role.role_arn
}

output "lb_policy_arn" {
  value = module.loadbalancer_policy.policy_arn
}
output "external_policy_arn" {
  value = module.route53_policy.policy_arn
}

output "EFS_id" {
  value = module.efs.efs_id
}
