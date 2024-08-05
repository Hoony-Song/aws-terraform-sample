resource "aws_ses_domain_identity" "example" {
  domain = var.host_name  
}
