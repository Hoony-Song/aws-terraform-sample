# 로드밸런서 이름
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

# VPC
variable "vpc_id" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "instance_name" {
  type = string
}

 variable "public_subnets" {
   type    = list
 }

variable "security_group_id" {
  type = string
}

variable "tags" { 
  type = map(string)
}

# 기본 이름 접두사
 

 variable "acm_arn" {
  default = null
   type = string
 }

 variable "host_pattern" {
   type = string
 }
