//ebs볼륨 사이즈 
variable "ebs_size_GB" {
  type = number
  default = 20
}

variable "ebs_volume_type" {
  type = string
  default = "gp3"
}

//default태그 설정 
variable "tags" { 
  type = map(string)
}

// name tag
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

//가용영역
variable "availability_zone_name" {
  type = string 
}

variable "instance_id" {
  type = string 
}

//지정 할 ebs경로  
variable "ebs_device_name" {
  type = string 
}