resource "aws_iam_role" "role_templatejson" {
  name = "${var.name}"

  assume_role_policy = templatefile("${var.jsonPath}",{
    ACCOUNT_ID = var.ACCOUNT_ID
    OIDC_PROVIDER = var.OIDC_PROVIDER
    NAME = var.OIDC_NAME != "" ? var.OIDC_NAME : var.name
  })
  tags = var.tags
}

