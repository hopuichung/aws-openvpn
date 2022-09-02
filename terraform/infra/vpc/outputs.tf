output "openvpn_vpc_id" {
  value = aws_vpc.openvpn_vpc.id
}

output "openvpn_vpc_public_subnet_1_id" {
  value = aws_subnet.openvpn_vpc_public_subnet_1.id
}

output "openvpn_vpc_public_subnet_2_id" {
  value = aws_subnet.openvpn_vpc_public_subnet_2.id
}

output "openvpn_vpc_private_subnet_1_id" {
  value = aws_subnet.openvpn_vpc_private_subnet_1.id
}

output "openvpn_vpc_private_subnet_2_id" {
  value = aws_subnet.openvpn_vpc_private_subnet_2.id
}

output "openvpn_ec2_security_group_id" {
  value = aws_security_group.openvpn_ec2_security_group.id
}

# output "openvpn_alb_security_group_id" {
#   value = aws_security_group.openvpn_alb_security_group.id
# }