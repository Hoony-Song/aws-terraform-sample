data "tls_certificate" "example" {
  url = var.oidc_url
}
resource "aws_iam_openid_connect_provider" "example" {
  
  url              = var.oidc_url
  client_id_list   = ["${var.client_id}"]
  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
  
  tags = var.tags
}