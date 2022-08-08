variable "openvpn_vpc_id" {
  type        = string
  default     = ""
  description = "OpenVPN VPC ID"
}

variable "openvpn_alb_sg_id" {
  type        = string
  default     = ""
  description = "OpenVPN ALB Security Group ID"
}

variable "openvpn_admin_ip_whitelist" {
  type        = list(any)
  default     = []
  description = "IP addresses that can connect to the openvpn admin"
}

variable "openvpn_vpc_public_subnet_1_id" {
  type        = string
  default     = ""
  description = "VPC Public Subnet 1 ID"
}

variable "openvpn_vpc_public_subnet_2_id" {
  type        = string
  default     = ""
  description = "VPC Public Subnet 2 ID"
}