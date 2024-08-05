
# 타겟그룹 이름
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

# 타겟그룹 타입  
variable "target_type" {
    type = string
    default = "instance"
}

# 타겟 포트 
variable "port" {
  type = number
  default = 80
}

# VPC_ID 
variable "vpc_id" {
  type = string
}

# 타겟 프로토콜
variable "protocol" {
  type = string
}

# 기본태그
variable "tags" { 
  type = map(string)
}

# 기본 이름 접두사
 