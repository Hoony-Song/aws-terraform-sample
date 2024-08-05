resource "aws_iam_user" "user" {
  name = var.user_name
  path          = "/"
  tags = var.tags
}
resource "aws_iam_access_key" "user" {
  user = var.user_name  
  depends_on = [aws_iam_user.user  ]
}
