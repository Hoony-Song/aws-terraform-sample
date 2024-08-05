# 클러스터 이름 
variable "cluster_name" {
  type = string
}

# 노드그룹 이름 
variable "node_group_name" {
  type = string
}

# 노드의 이름
variable "node_name" {
  type = string
}

#노드 인스턴스 타입
variable "eks_inst_type" {
    type = list(string)
}

# vpc 
 variable "vpc_id" {
   type    = string
 }

 # 프라이빗 서브넷
 variable "private_subnets" {
   type    = list
 }

 # 보안그룹 
variable "security_group_id" {
  type = string
}

# 기본 태그
variable "tags" { 
  type = map(string)
}

# 생성시 이름 앞 접두사
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
} 

# 클러스터 롤 arn 
variable "cluster_role_arn" {
  type = string
}

# 노드 롤 arn 
variable "node_role_arn" {
  type = string
}

# 사용 할 쿠버네티스 버전
variable "kube_version" {
  type = string
  default = "1.27"
}

# 오토 스케일링 
variable "desired_size" {
  type = number
  default = 1
}
variable "min_size" {
  type = number
  default = 1
}
variable "max_size" {
  type = number
  default = 3
}

# 시작템플릿 버전 ( 버전을 명시하지 않으면 Latest 버전을 기본적으로 사용)
variable "LT_version" {
  type = string
  default = "$Latest"
}

# 노드의 볼륨사이즈
variable "root_volumes_size" {
  type = number
  default = 20
}

# pem 키 이름
variable "key_name" {
  type = string
}

variable "capacity_type" {
  type = string
  default = "ON_DEMAND"
}

