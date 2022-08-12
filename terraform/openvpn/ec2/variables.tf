variable "openvpn_ec2_ami" {
  type        = string
  default     = "ami-079176f64e2f11364" # default ap-east-1 openvpn access server ami
  description = "EC2 AMI to be used"
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "domain name for route 53 custom domain"
}

variable "openvpn_hostname" {
  type        = string
  default     = ""
  description = "hostname to be used for openvpn"
}

variable "openvpn_server_username" {
  type        = string
  default     = "openvpn"
  description = "Admin username to access server"
}

variable "openvpn_server_password" {
  type        = string
  default     = "password"
  description = "Admin password to access server"
}

variable "openvpn_admin_ip_whitelist" {
  type        = list(any)
  default     = []
  description = "IP addresses that can connect to the openvpn admin"
}

variable "vpc_private_subnet_1_cidr" {
  type        = string
  default     = "172.16.2.0/24"
  description = "VPC Public Subnet CIDR"
}

variable "vpc_private_subnet_2_cidr" {
  type        = string
  default     = "172.16.3.0/24"
  description = "VPC Public Subnet CIDR"
}

variable "openvpn_ec2_security_group_id" {
  type        = string
  default     = ""
  description = "EC2 Security Group ID"
}

variable "openvpn_vpc_private_subnet_1_id" {
  type        = string
  default     = ""
  description = "OpenVPN VPC Private Subnet 1 ID"
}

variable "openvpn_vpc_public_subnet_1_id" {
  type        = string
  default     = ""
  description = "OpenVPN VPC Public Subnet 1 ID"
}