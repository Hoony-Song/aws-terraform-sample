variable "dns_name" {
 type = string
}

variable "zone_id" {
 type = string
}

variable "domain_name" {
 type = string
}

variable "host_name" {
 type = string
}
variable "record_type" {
 type = string
 default = "A"
}
