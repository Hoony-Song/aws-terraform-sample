
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
