output "oidc_url" {
  value = aws_eks_cluster.terraform-eks-cluster.identity.0.oidc.0.issuer
}

output "cluster_id" {
  value = aws_eks_cluster.terraform-eks-cluster.cluster_id
}

output "endpoint" {
  value = aws_eks_cluster.terraform-eks-cluster.endpoint
}
# output "client_certificate" {
#   value = aws_eks_cluster.terraform-eks-cluster.client_certificate[0].data
# }
# output "client_key" {
#   value = aws_eks_cluster.terraform-eks-cluster.client_key[0].data
# }

output "ca_certificate" {
  value = aws_eks_cluster.terraform-eks-cluster.certificate_authority[0].data
}

output "token" {
  value = data.aws_eks_cluster_auth.example.token
  depends_on  = [aws_eks_cluster.terraform-eks-cluster]
}
