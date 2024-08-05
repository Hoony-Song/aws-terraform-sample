output "username" {
  value = aws_iam_access_key.user.id
}

output "password" {
  value = aws_iam_access_key.user.ses_smtp_password_v4
}

output "secret_key" {
  value = aws_iam_access_key.user.secret
}