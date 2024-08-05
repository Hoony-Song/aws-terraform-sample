locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
resource "aws_db_subnet_group" "subnet-group" {
  name       = "${var.prefix_name}-${terraform.workspace}-${var.name}"     //생성 할  서브넷 그룹 이름
  subnet_ids = var.rds_subnet_ids[*].id             //서브넷 그룹 생성

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}

resource "aws_db_instance" "rds" {
  identifier = "${var.prefix_name}-${terraform.workspace}-${var.name}"                   //DB 인스턴스 식별자
  db_subnet_group_name = aws_db_subnet_group.subnet-group.id         //서브넷 그룹
  engine               = var.rds_engine                              //db 종류
  engine_version       = var.rds_engine_version                      //db 버전
  instance_class       = var.rds_inst_type                           //DB 인스턴스 클래스
  username             = var.rds_username                            //마스터 사용자 이름
  password             = var.rds_password                            //마스터 암호
  parameter_group_name = var.rds_parameter_group_name                //DB 파라미터 그룹
  allocated_storage     = var.rds_vol_allocated_size                 //할당된 스토리지
  max_allocated_storage = var.rds_vol_max_allocated_size             //최대 스토리지 임계값
  publicly_accessible = var.rds_public_acces                         //퍼블릭액세스 가능
  vpc_security_group_ids = [var.rds_security_group_id]               //기본 VPC 보안 그룹  
  availability_zone = var.rds_subnet_ids[var.rds_region].availability_zone                     //가용 영역
  port = var.rds_port                                                   //데이터베이스 포트
  skip_final_snapshot  = true

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}