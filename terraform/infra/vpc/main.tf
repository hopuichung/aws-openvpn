# Dedicated VPC Setup
resource "aws_vpc" "openvpn_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name   = "openvpn-vpc"
    Module = "vpc"
  }
}

# Subnet Setup
## Public subnets
resource "aws_subnet" "openvpn_vpc_public_subnet_1" {
  vpc_id            = aws_vpc.openvpn_vpc.id
  cidr_block        = var.vpc_public_subnet_1_cidr
  availability_zone = "${var.server_region}a"

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-vpc"
    Module  = "vpc"
  }
}

resource "aws_subnet" "openvpn_vpc_public_subnet_2" {
  vpc_id            = aws_vpc.openvpn_vpc.id
  cidr_block        = var.vpc_public_subnet_2_cidr
  availability_zone = "${var.server_region}b"

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-vpc"
    Module  = "vpc"
  }
}

## Private subnets
resource "aws_subnet" "openvpn_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.openvpn_vpc.id
  cidr_block        = var.vpc_private_subnet_1_cidr
  availability_zone = "${var.server_region}a"

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-vpc"
    Module  = "vpc"
  }
}

resource "aws_subnet" "openvpn_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.openvpn_vpc.id
  cidr_block        = var.vpc_private_subnet_2_cidr
  availability_zone = "${var.server_region}b"

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-vpc"
    Module  = "vpc"
  }
}

# Network interface
resource "aws_network_interface" "openvpn_public_vpc_interface_1" {
  subnet_id = aws_subnet.openvpn_vpc_public_subnet_1.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-public-network-interface-1"
    Module  = "vpc"
  }
}

resource "aws_network_interface" "openvpn_public_vpc_interface_2" {
  subnet_id = aws_subnet.openvpn_vpc_public_subnet_2.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-public-network-interface-2"
    Module  = "vpc"
  }
}

resource "aws_network_interface" "openvpn_private_vpc_interface_1" {
  subnet_id = aws_subnet.openvpn_vpc_private_subnet_1.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-private-network-interface-1"
    Module  = "vpc"
  }
}

resource "aws_network_interface" "openvpn_private_vpc_interface_2" {
  subnet_id = aws_subnet.openvpn_vpc_private_subnet_2.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-private-network-interface-2"
    Module  = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.openvpn_vpc.id

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-internet-gateway"
    Module  = "vpc"
  }
}

# Route
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

# EIP settings
# resource "aws_eip" "openvpn_eip" {
#   vpc = true
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.openvpn_server.id
#   allocation_id = aws_eip.openvpn_eip.id
# }

# EC2 Security group
resource "aws_security_group" "openvpn_ec2_security_group" {
  name        = "openvpn-ec2-security-group"
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

resource "aws_security_group_rule" "openvpn_ec2_tcp_ingress_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.openvpn_admin_ip_whitelist
  security_group_id = aws_security_group.openvpn_ec2_security_group.id
}

resource "aws_security_group_rule" "openvpn_ec2_tcp_ingress_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = var.openvpn_admin_ip_whitelist
  security_group_id = aws_security_group.openvpn_ec2_security_group.id
}

resource "aws_security_group_rule" "openvpn_ec2_tcp_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_private_subnet_1_cidr, var.vpc_private_subnet_2_cidr, "0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_ec2_security_group.id
}

resource "aws_security_group_rule" "openvpn_ec2_udp_ingress_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = [var.vpc_private_subnet_1_cidr, var.vpc_private_subnet_2_cidr, "0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_ec2_security_group.id
}

# alb Security Group
resource "aws_security_group" "openvpn_alb_security_group" {
  name        = "openvpn-alb-security-group"
  description = "Controll network access port for openvpn alb"
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

resource "aws_security_group_rule" "openvpn_alb_tcp_ingress_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.openvpn_admin_ip_whitelist
  security_group_id = aws_security_group.openvpn_alb_security_group.id
}

resource "aws_security_group_rule" "openvpn_alb_tcp_ingress_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = var.openvpn_admin_ip_whitelist
  security_group_id = aws_security_group.openvpn_alb_security_group.id
}

resource "aws_security_group_rule" "openvpn_alb_tcp_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_alb_security_group.id
}

resource "aws_security_group_rule" "openvpn_alb_udp_ingress_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openvpn_alb_security_group.id
}