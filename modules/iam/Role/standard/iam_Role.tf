resource "aws_iam_role" "role_json" {
  name = "${var.name}"
  assume_role_policy = file("${var.jsonPath}")  
  tags = var.tags
}
