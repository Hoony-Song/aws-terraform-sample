# vpcID
output "vpc_id" {
  value = aws_vpc.vpc.id
}

#프라이빗 서브넷
output "private_subnets" {
  value = aws_subnet.private-subnets[*]
}

#퍼블릭 서브넷
output "pub_subnets" {
  value = aws_subnet.public-subnets[*]
}
