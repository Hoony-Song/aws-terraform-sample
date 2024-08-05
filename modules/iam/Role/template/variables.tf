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
variable "OIDC_NAME" {
  type = string
  default = ""
}

variable "ACCOUNT_ID" {
  type = string
}

variable "OIDC_PROVIDER" {
  type = string
}
variable "tags" { 
  type = map(string)
}