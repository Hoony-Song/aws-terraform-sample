locals {
  vpc_name = "vpc"
  internet_gateway_name = "igw-priv"
  nat_gateway_name = "ngw-pub"
  pub_rt_name = "rt-pub"
  priv_rt_name = "rt-priv"
  vpc_cidr_bloak = "10.0.0.0/16"
  
  pub_subnets= [
    {
      name           = "pub-1"
      cidr_block     = "10.0.0.0/18"
      availability_zone = "ap-northeast-2a"
    },
    {
      name           = "pub-2"
      cidr_block     = "10.0.64.0/18"
      availability_zone = "ap-northeast-2c"
    },
  ]

  priv_subnets= [
    {
      name           = "priv-1"
      cidr_block     = "10.0.128.0/18"
      availability_zone = "ap-northeast-2a"
    },
    {
      name           = "priv-2"
      cidr_block     = "10.0.192.0/18"
      availability_zone = "ap-northeast-2c"
    },
  ]  
}


module "vpc" {
  source       = "../../../modules/compute/vpc" 
  pub_subnets = local.pub_subnets
  priv_subnets = local.priv_subnets
  name = local.vpc_name
  vpc_cidr_bloak = local.vpc_cidr_bloak

  internet_gateway_name = local.internet_gateway_name
  nat_gateway_name = local.nat_gateway_name
  pub_rt_name = local.pub_rt_name
  priv_rt_name = local.priv_rt_name

  prefix_name = var.prefix_name.Owner
  tags = var.resource_tag
}


