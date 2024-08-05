# 서비스 어카운트 이름
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

# 네임스페이스 
variable "namespace" {
  type = string
  default = "kube-system"
}

# 라벨 매니저 지정
variable "labels_managed" {
  type = string
  default = "terraform"
}

# oidc role
variable "role_arn" {
  type = string
}