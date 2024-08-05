variable "name" {
  type = string
  default = "Redirect"
}
variable "listener_arn" {
  type = string
}

variable "rule_type" {
  type = string
  default = "redirect"
}
variable "redirect_state_code" {
  type = string
  default = "HTTP_301"
}

variable "redirect_protocol" {
    type = string
    default = "#{protocol}"  
}

variable "redirect_port" {
    type = string  
}

variable "redirect_pattern_path" {
  type = string
}

variable "priority" {
  type = number
}
