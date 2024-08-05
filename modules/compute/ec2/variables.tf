# VPC

# 프라이빗 서브넷1
variable "subnet_id" {
  type = list
}

# 인스턴스 네임
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

# 인스턴스 타입
variable "instance_type" {
  type = string 
}

# region 지정
variable "region" {
  type = number
}

# security_group_id
variable "security_group_id" {
  type = string
}

//기본 태그지정 
variable "tags" { 
  type = map(string)
}


//외부 고정ip (탄력적ip) 사용 여부 
variable "attached_external_IP" {
  type = bool
  default = false
}

//기본 ebs 볼륨 용량
variable "volume_size_GB" {
  type = number
  default = 20
}

# 볼륨 타입
variable "volume_type" {
  type = string
  default = "gp3"
}

//ami \
 variable "default_ami" {
   type = string
 }

 # default pem key name 
 variable "key_name" {
  type = string
}

variable "private_ip" {
  type = string
}

variable "user_data" {}
