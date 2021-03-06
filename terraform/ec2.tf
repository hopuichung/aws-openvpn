# EC2 instance
resource "aws_instance" "openvpn_server" {
  ami                    = "ami-079176f64e2f11364"
  instance_type          = "t3.nano"
  key_name               = "michaelho2022"
  subnet_id              = aws_subnet.openvpn_vpc_subnet.id
  vpc_security_group_ids = [aws_security_group.openvpn_security_group.id]

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-server"
  }
}

# EIP settings
resource "aws_eip" "openvpn_eip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.openvpn_server.id
  allocation_id = aws_eip.openvpn_eip.id
}