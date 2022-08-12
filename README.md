# aws-openvpn
This project is for recording my setup for OpenVPN back to HK.

## Prerequisite
- Have an AWS account
- Have the aws credential setup for terraform setup
- Have the corresponding s3 bucket and dynamodb setup for terraform state and the ec2 private key set
  - In my case, bucket: mhho-terraform-openvpn-backend & ddb table: mhho-terraform-openvpn-state
- Have the terraform cli and awscli installed
- Subscribed to the AWS Marketplace openvpn access server image, replace the AMI ID correspondingly in ec2.tf
  - I am running the server in ap-east-1 region and the latest ami id is ami-079176f64e2f11364 as of May 2022
- Having the no-ip ddns created
  - for using hostname to connect to openvpn server instead of using the ec2 public ip

### Optional
- Having domain and created certificate

## Overall Steps
- (Optional) Setup route 53 domain first in AWS
- Setup the AWS infra for OpenVPN server using EC2 in ap-east-1 region by terraform
  - `terraform init`
  - `terraform plan -out tfplan -var-file="ap-east-1.tfvars"`
  - `terraform apply tfplan`
- Login to the ec2 with "openvpnas" user
- Follow https://openvpn.net/vpn-server-resources/amazon-web-services-ec2-tiered-appliance-quick-start-guide/
<!-- - Setup no-ip ddns, follow https://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client-on-ubuntu/
  - choose the ens interface for the no-ip client -->
- Go to the https://{your-domain-name}:943/ for the admin page to configure the correct domain name and download the ovpn file
- Use the ovpn file to connect and verify can establish the openvpn connection