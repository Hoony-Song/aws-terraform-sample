variable "jsonPath" {
  type = string
}
variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

variable "tags" { 
  type = map(string)
}