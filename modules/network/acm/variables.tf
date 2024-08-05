
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



variable "host_pattern" {
  type = string
}