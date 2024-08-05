variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}
variable "jsonPath" {
  type = string
}

variable "values_file" {
  type = map(any)
  default = {}
}

variable "tags" { 
  type = map(string)
}