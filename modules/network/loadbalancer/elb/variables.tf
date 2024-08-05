# 로드밸런서 이름
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

# 로드밸런서 타입
variable "load_balancer_type" {
  type = string
}

# 퍼블릭 서브넷
 variable "public_subnets" {
   type    = list
 }

 # 보안 그룹 ID
variable "security_group_id" {
  type = string
}

# 기본 태그 
variable "tags" { 
  type = map(string)
}
# ACM
 variable "acm_arn" {
  default = null
   type = string
 }

# 기본 이름 접두사
 