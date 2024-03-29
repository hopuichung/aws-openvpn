server_region              = "ap-east-1"
server_ec2_ami             = "ami-079176f64e2f11364"
domain_name                = "test.com"
openvpn_hostname           = "ovpn.test.com"
openvpn_server_username    = "openvpn"
openvpn_server_password    = "password"
vpc_cidr                   = "172.16.0.0/16"
vpc_public_subnet_1_cidr   = "172.16.0.0/24"
vpc_public_subnet_2_cidr   = "172.16.1.0/24"
vpc_private_subnet_1_cidr  = "172.16.2.0/24"
vpc_private_subnet_2_cidr  = "172.16.3.0/24"
openvpn_admin_ip_whitelist = ["0.0.0.0/0"]
cost_alert_emails          = ["test@test.com"]
lets_encrypt_email         = "test@test.com"