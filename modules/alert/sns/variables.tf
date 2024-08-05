variable "name" {
  type = string
  default = "unknown"
}

variable "prefix_name" {
  type = string
  default = "unknown"
}

variable "delivery_policy" {
  type = string
}
variable "tags" { 
  type = map(string)
}

variable "policy" {
  type = string
}
