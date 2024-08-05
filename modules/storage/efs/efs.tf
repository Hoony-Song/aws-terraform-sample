locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
//ebs 볼륨 장착 
resource "aws_efs_file_system" "efs" {

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}

resource "aws_efs_mount_target" "alpha" {
  count          = length(var.private_subnets)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.private_subnets[count.index].id
  security_groups = ["${var.security_group_id}"]
}