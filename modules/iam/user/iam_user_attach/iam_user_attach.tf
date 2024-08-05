resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = var.user_name
  policy_arn = var.policy_arn
}

