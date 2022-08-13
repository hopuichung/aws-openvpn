# EC2 instance
resource "aws_instance" "openvpn_server" {
  ami           = var.openvpn_ec2_ami
  instance_type = "t3.micro"
  key_name      = "michaelho2022"
  # subnet_id              = var.openvpn_vpc_private_subnet_1_id
  subnet_id              = var.openvpn_vpc_public_subnet_1_id
  vpc_security_group_ids = [var.openvpn_ec2_security_group_id]
  user_data              = <<EOF
#!/bin/bash

# Setup Let's Encrypt cert, --dry-run for testing
add-apt-repository ppa:certbot/certbot -y
apt-get update -y
apt install certbot -y
# certbot certonly --standalone --preferred-challenges http -d ${var.openvpn_hostname} -m ${var.lets_encrypt_email} -n --agree-tos --dry-run
certbot certonly --standalone --preferred-challenges http -d ${var.openvpn_hostname} -m ${var.lets_encrypt_email} -n --agree-tos

# setup cert config for openvpnas
/usr/local/openvpn_as/scripts/sacli --key "cs.priv_key" --value_file "/etc/letsencrypt/live/${var.openvpn_hostname}/privkey.pem" ConfigPut
/usr/local/openvpn_as/scripts/sacli --key "cs.cert" --value_file "/etc/letsencrypt/live/${var.openvpn_hostname}/fullchain.pem" ConfigPut

# Add debug log for aws info for openvpn service
echo "DEBUG_AWSINFO=1" >> /usr/local/openvpn_as/etc/as.conf
echo "DEBUG=true" >> /usr/local/openvpn_as/etc/as.conf

# Setup public hostname
public_hostname=${var.openvpn_hostname}

# Route user internet traffic via openvpn
reroute_gw=1

# Route user DNS queries via openvpn
reroute_dns=1

# Setup admin
admin_user=${var.openvpn_server_username}
admin_pw=${var.openvpn_server_password}

# Restart Admin
/usr/local/openvpn_as/scripts/sacli start

# Setup automated script for refreshing Let's Encrypt cert
echo "#!/bin/bash" > /usr/local/sbin/certrenewal.sh
echo "certbot renew — standalone" >> /usr/local/sbin/certrenewal.sh
echo "sleep 1m" >> /usr/local/sbin/certrenewal.sh
echo "/usr/local/openvpn_as/scripts/sacli --key "cs.priv_key" --value_file "/etc/letsencrypt/live/${var.openvpn_hostname}/privkey.pem" ConfigPut" >> /usr/local/sbin/certrenewal.sh
echo "/usr/local/openvpn_as/scripts/sacli --key "cs.cert" --value_file "/etc/letsencrypt/live/${var.openvpn_hostname}/fullchain.pem" ConfigPut" >> /usr/local/sbin/certrenewal.sh
echo "/usr/local/openvpn_as/scripts/sacli start" >> /usr/local/sbin/certrenewal.sh

# Make the script Executable
chmod +x /usr/local/sbin/certrenewal.sh

# Setup schedule job
crontab -l | { cat; echo "0 0 1 */2 * /usr/local/sbin/certrenewal.sh"; } | crontab -

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

# Create custom domain record for ec2
data "aws_route53_zone" "myzone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "ec2" {
  zone_id = data.aws_route53_zone.myzone.zone_id
  name    = "openvpn.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [
    aws_instance.openvpn_server.public_ip
  ]
}