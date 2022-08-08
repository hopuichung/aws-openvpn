# EC2 instance
resource "aws_instance" "openvpn_server" {
  ami                    = var.openvpn_ec2_ami
  instance_type          = "t3.nano"
  key_name               = "michaelho2022"
  # subnet_id              = var.openvpn_vpc_private_subnet_1_id
  subnet_id              = var.openvpn_vpc_public_subnet_1_id
  vpc_security_group_ids = [var.openvpn_ec2_security_group_id]
  user_data              = <<EOF
#!/bin/bash

# Add debug log for aws info for openvpn service
echo "DEBUG_AWSINFO=1" >> /usr/local/openvpn_as/etc/as.conf

# Setup public hostname
public_hostname=${var.openvpn_hostname}

# Route user internet traffic via openvpn
reroute_gw=1

# Route user DNS queries via openvpn
reroute_dns=1

# Setup admin
admin_user=${var.openvpn_server_username}
admin_pw=${var.openvpn_server_password}

EOF

  tags = {
    Project = "openvpn-server"
    Name    = "openvpn-server"
    Module  = "ec2"
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
