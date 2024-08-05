
# vpc 이름
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

# 태그
variable "tags" { 
  type = map(string)
}

#퍼블릭 서브넷 정보
variable "pub_subnets" {
  description = "Public subnets to create"
  type        = list(object({
    name             = string
    cidr_block       = string
    availability_zone= string
  }))
}

# 프라이빗 서브넷 정보
variable "priv_subnets" {
  description = "Private subnets to create"
  type        = list(object({
    name             = string
    cidr_block       = string
    availability_zone= string
  }))
}


# 인터넷 게이트 웨이 이름
variable "internet_gateway_name" {
  type = string  
}

# NAT 게이트웨이 이름
variable "nat_gateway_name" {
  type = string  
}

# 퍼블릭 라우팅 테이블 이름
variable "pub_rt_name" {
  type = string  
}

# 프라이빗 라우팅 테이블 이름
variable "priv_rt_name" {
  type = string  
}

variable "vpc_cidr_bloak" {
  type = string
}