# 프라이빗 IP
output "private_ip" {
  value = aws_instance.ec2.private_ip
}
output "instance_id" {
  value = aws_instance.ec2.id
}
output "availability_zone" {
  value = aws_instance.ec2.availability_zone

}

output "public_eip" {
  value = try(aws_eip.eip[0].public_ip, "No EIP address available")
}

