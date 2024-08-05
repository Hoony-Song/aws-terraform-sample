locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_instance" "ec2" {  
  ami           = var.default_ami #"ami-0263588f2531a56bd"               //AMI 선택
  instance_type = var.instance_type                                     //인스턴스 유형
  key_name = var.key_name                                               //기존 키 페어 선택
  private_ip = var.private_ip                                           //내부 ip 고정
  subnet_id = var.subnet_id[var.region].id
  vpc_security_group_ids = [var.security_group_id] 
  availability_zone = var.subnet_id[var.region].availability_zone
  user_data = var.user_data
  //기본 스토리지 추가
  root_block_device  {
      volume_size = var.volume_size_GB              //크기(GiB)
      volume_type = var.volume_type                         //볼륨 유형
      tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-root-${var.name}"
  })

  }
  lifecycle {
    create_before_destroy = true
  }
  timeouts {
    create = "20m"
  }

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}

resource "aws_eip" "eip" {
  count = var.attached_external_IP ? 1 : 0

  instance = aws_instance.ec2.id
  vpc      = true

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}
