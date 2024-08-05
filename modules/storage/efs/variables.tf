
//default태그 설정 
variable "tags" { 
  type = map(string)
}


variable "name" {
  type = string 
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

variable "private_subnets" {
   type    = list
 }

variable "security_group_id" {
  type = string
}
