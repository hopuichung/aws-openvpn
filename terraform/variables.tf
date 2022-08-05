variable "server_region" {
  type        = string
  default     = "ap-east-1"
  description = "openvpn server default region - Hong Kong"
}

variable "openvpn_ec2_ami" {
  type        = string
  default     = "ami-079176f64e2f11364" # default ap-east-1 openvpn access server ami
  description = "EC2 AMI to be used"
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

