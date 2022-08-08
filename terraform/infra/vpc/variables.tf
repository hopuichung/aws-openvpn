variable "server_region" {
  type        = string
  default     = "ap-east-1"
  description = "openvpn server default region - Hong Kong"
}

variable "vpc_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "VPC CIDR"
}

variable "vpc_public_subnet_1_cidr" {
  type        = string
  default     = "172.16.0.0/24"
  description = "VPC Public Subnet CIDR"
}

variable "vpc_public_subnet_2_cidr" {
  type        = string
  default     = "172.16.1.0/24"
  description = "VPC Public Subnet CIDR"
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

variable "openvpn_admin_ip_whitelist" {
  type        = list(any)
  default     = []
  description = "IP addresses that can connect to the openvpn admin"
}