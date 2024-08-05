resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  policy_arn = var.policy_arn
  role       = "${var.role_name}"
}