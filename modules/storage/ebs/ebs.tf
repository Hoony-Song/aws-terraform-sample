locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
//ebs 볼륨 장착 
resource "aws_volume_attachment" "ebs" {
  device_name = var.ebs_device_name                 //ebs볼륨 경로 설정 
  volume_id   = aws_ebs_volume.volume.id            //장착 할 ebs 볼륨 id 
  instance_id = var.instance_id                   //장착 할 instance id 
}

//ebs 볼륨 생성
resource "aws_ebs_volume" "volume" {
  availability_zone = var.availability_zone_name      //가용영역
  size              = var.ebs_size_GB                 //ebs 볼륨 용량 
  type = var.ebs_volume_type
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}
