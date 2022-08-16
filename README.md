# aws-openvpn
This project is for showing my setup for OpenVPN back to HK (ap-east-1) using AWS. It will use the "Let's Encrypt" service to create proper certificate for OpenVPN server.

## Prerequisite
- Have an AWS account
- Have the aws IAM user credential setup for terraform setup (Access Key)
- Have the corresponding s3 bucket and dynamodb setup for terraform state and the ec2 private key set
  - In my case, bucket: mhho-terraform-openvpn-backend & ddb table: mhho-terraform-openvpn-state
- Have the terraform cli and awscli installed
- Subscribed to the AWS Marketplace openvpn access server image, replace the AMI ID correspondingly in ec2.tf
  - Related marketplace URL: https://aws.amazon.com/marketplace/pp/prodview-y3m73u6jd5srk
  - I am running the server in ap-east-1 region and the latest ami id is ami-079176f64e2f11364 as of May 2022
- Have a domain created
  - in AWS Route 53 or
  - in no-ip ddns
- Have EC2 Private SSH Key created

## Overall Steps
- Setup the variable file for terraform. In my case, I use the region name `ap-east-1.tfvars`. You may refer to the `terraform/sample.tfvars` for the content.
- Setup the AWS infra for OpenVPN server using EC2 in ap-east-1 region by terraform
  - `terraform init`
  - `terraform plan -out tfplan -var-file="ap-east-1.tfvars"`
  - `terraform apply tfplan`
- Login to the ec2 with "openvpnas" user with the EC2 Private SSH Key
- Go to the https://{your-domain-name}:943/ for the admin page to download the ovpn file
- Use the ovpn file to connect and verify can establish the openvpn connection