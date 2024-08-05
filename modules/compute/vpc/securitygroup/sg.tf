locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_security_group" "SG" {
  name        = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  vpc_id      = var.vpc_id


  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}

resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.ingress_rules)
  
  type              = "ingress"
  security_group_id = aws_security_group.SG.id
  
  description       = var.ingress_rules[count.index].description
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  
  cidr_blocks       = var.ingress_rules[count.index].cidr_blocks 
}

resource "aws_security_group_rule" "egress_rules" {
  count             = length(var.egress_rules)
  
  type              = "egress"
  security_group_id = aws_security_group.SG.id
  
  from_port         = var.egress_rules[count.index].from_port
  to_port           = var.egress_rules[count.index].to_port
  protocol          = var.egress_rules[count.index].protocol
  
  cidr_blocks       = var.egress_rules[count.index].cidr_blocks 
}



# resource "aws_security_group" "sg4-alb" {
#   name        = "${var.prefix_name}-${terraform.workspace}-${var.default_name.role}-${var.default_name.suf_role4}"
#   vpc_id      = var.vpc_id

#   # 인바운드 규칙   
#   ingress {
#     description      = ""
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
  
#   ingress {
#     description      = ""
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = merge(local.resource_tag,{
#     Name = "${var.prefix_name}-${terraform.workspace}-${var.default_name.role}-${var.default_name.suf_role4}"
#   })
# }

# resource "aws_security_group" "sg5-eks" {
#   name        = "${var.prefix_name}-${terraform.workspace}-${var.default_name.role}-${var.default_name.suf_role5}"
#   vpc_id      = var.vpc_id

#   # 인바운드 규칙

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = merge(local.resource_tag,{
#     Name = "${var.prefix_name}-${terraform.workspace}-${var.default_name.role}-${var.default_name.suf_role5}"
#   })
# }