variable "server_region" {
  type        = string
  default     = "ap-east-1"
  description = "openvpn server default region - Hong Kong"
}

variable "server_username" {
  type        = string
  default     = "openvpn"
  description = "Admin username to access server"
}

variable "server_password" {
  type        = string
  default     = "password"
  description = "Admin password to access server"
}

