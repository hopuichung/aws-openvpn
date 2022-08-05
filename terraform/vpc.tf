# Dedicated VPC Setup
resource "aws_vpc" "openvpn_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "openvpn-vpc"
  }
}

resource "aws_subnet" "openvpn_vpc_subnet" {
  vpc_id            = aws_vpc.openvpn_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "${var.server_region}a"

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-vpc"
  }
}

resource "aws_network_interface" "openvpn_vpc_interface" {
  subnet_id = aws_subnet.openvpn_vpc_subnet.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-primary-network-interface"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.openvpn_vpc.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-internet-gateway"
  }
}

resource "aws_route_table" "openvpn_route_table" {
  vpc_id = aws_vpc.openvpn_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_main_route_table_association" "openvpn_main_route_table_association" {
  vpc_id         = aws_vpc.openvpn_vpc.id
  route_table_id = aws_route_table.openvpn_route_table.id
}

resource "aws_security_group" "openvpn_security_group" {
  name        = "openvpn-security-group"
  description = "Controll network access port for openvpn"
  vpc_id      = aws_vpc.openvpn_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-security-group"
  }
}

resource "aws_security_group_rule" "openvpn_tcp_ingress_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["59.149.99.23/32"]
  security_group_id = aws_security_group.openvpn_security_group.id
}

resource "aws_security_group_rule" "openvpn_tcp_ingress_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["59.149.99.23/32"]
  security_group_id = aws_security_group.openvpn_security_group.id
}

resource "aws_security_group_rule" "openvpn_tcp_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_security_group.id
}

resource "aws_security_group_rule" "openvpn_udp_ingress_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_security_group.id
}