locals {
  resource_tag = merge(var.tags, { Area = terraform.workspace })
}
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_bloak //IPv4 CIDR 수동 입력
  instance_tenancy     = "default"     //테넌시 - 기본값
  enable_dns_hostnames = true

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.name}"
  })
}

resource "aws_subnet" "public-subnets" {  
  count           = length(var.pub_subnets)
  vpc_id                  = aws_vpc.vpc.id    //VPC ID
  cidr_block              = var.pub_subnets[count.index].cidr_block     //IPv4 CIDR 블록  
  availability_zone       = var.pub_subnets[count.index].availability_zone //가용 영역
  map_public_ip_on_launch = true
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.pub_subnets[count.index].name}"
    "kubernetes.io/role/elb"=""
  })

}

# 프라이빗 서브넷1
# 위치 : VPC > Virtual Private Cloud > 서브넷
resource "aws_subnet" "private-subnets" {
  count           = length(var.priv_subnets)
  vpc_id                  = aws_vpc.vpc.id    //VPC ID
  cidr_block              = var.priv_subnets[count.index].cidr_block     //IPv4 CIDR 블록  
  availability_zone       = var.priv_subnets[count.index].availability_zone //가용 영역
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.priv_subnets[count.index].name}"
    "kubernetes.io/role/internal-elb"=""
  })
}


# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id 
  
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.internet_gateway_name}"
  })
}

# 탄력적 IP 할당
resource "aws_eip" "eip" {
  vpc = true
  
  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-eip-pri"
  })
}

# NAT 게이트웨이
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id                //탄력적 IP 할당 ID
  subnet_id     = aws_subnet.public-subnets[0].id //퍼블릭 서브넷 1

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.nat_gateway_name}"
  })
}

# 퍼블릭 라우팅 테이블
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"                 //Destination (대상)
    gateway_id = aws_internet_gateway.igw.id //Target (대상)
  }

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.pub_rt_name}"
  })
}

# 프라이빗 라우팅 테이블
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"              //Destination (대상)
    gateway_id = aws_nat_gateway.natgw.id //Target (대상)
  }

  tags = merge(local.resource_tag,{
    Name = "${var.prefix_name}-${terraform.workspace}-${var.priv_rt_name}"
  })
}

# 퍼블릭 라우팅 테이블에 퍼블릭 서브넷 연결
resource "aws_route_table_association" "public-rt-associations" {
  count           = length(var.pub_subnets)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

# 프라이빗 라우팅 테이블에 프라이빗 서브넷 연결
resource "aws_route_table_association" "private-rt-association" {
  count           = length(var.priv_subnets)
  subnet_id      = aws_subnet.private-subnets[count.index].id   //private-subnets
  route_table_id = aws_route_table.private-rt.id
  
}



