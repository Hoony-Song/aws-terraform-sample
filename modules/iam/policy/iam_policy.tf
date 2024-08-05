resource "aws_iam_policy" "route" {
  name = var.name  
  policy = file("${var.jsonPath}") 
  
  tags = var.tags
}


