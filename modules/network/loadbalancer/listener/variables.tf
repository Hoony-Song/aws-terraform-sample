
variable "port" {
    type = string  
}

variable "protocol" {
  type = string
}

variable "load_balancer_arn" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ssl_attach" {
  type = bool
  default = false
} 

variable "ssl_policy" {
  type = string
  default = "ELBSecurityPolicy-2016-08"
} 
variable "target_type" {
  type = string
  default = "forward"
}

variable "host_pattern" {
  type = string
}


