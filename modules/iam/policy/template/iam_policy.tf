resource "aws_iam_policy" "tpl_policy" {
  name = var.name  
  
  # policy = file("${var.jsonPath}") 
  policy = templatefile(var.jsonPath,var.values_file)  
  tags = var.tags
}


