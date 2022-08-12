terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket         = "mhho-terraform-openvpn-backend"
    key            = "terraform.tfstate"
    region         = "ap-east-1"
    dynamodb_table = "mhho-terraform-openvpn-state"
  }
}

provider "aws" {
  profile = "default"
  region  = var.server_region
}

# budget setting
resource "aws_budgets_budget" "cost" {
  name         = "budget-monthly"
  time_unit    = "MONTHLY"
  budget_type  = "COST"
  limit_amount = "15"
  limit_unit   = "USD"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.cost_alert_emails
  }
}

# VPC
module "vpc" {
  source = "./infra/vpc"

  server_region              = var.server_region
  vpc_cidr                   = var.vpc_cidr
  vpc_public_subnet_1_cidr   = var.vpc_public_subnet_1_cidr
  vpc_public_subnet_2_cidr   = var.vpc_public_subnet_2_cidr
  vpc_private_subnet_1_cidr  = var.vpc_private_subnet_1_cidr
  vpc_private_subnet_2_cidr  = var.vpc_private_subnet_2_cidr
  openvpn_admin_ip_whitelist = var.openvpn_admin_ip_whitelist
}

# openvpn
module "openvpn_ec2" {
  source = "./openvpn/ec2"

  openvpn_ec2_ami                 = var.openvpn_ec2_ami
  domain_name                     = var.domain_name
  openvpn_hostname                = var.openvpn_hostname
  openvpn_server_username         = var.openvpn_server_username
  openvpn_server_password         = var.openvpn_server_password
  openvpn_admin_ip_whitelist      = var.openvpn_admin_ip_whitelist
  vpc_private_subnet_1_cidr       = var.vpc_private_subnet_1_cidr
  vpc_private_subnet_2_cidr       = var.vpc_private_subnet_2_cidr
  openvpn_ec2_security_group_id   = module.vpc.openvpn_ec2_security_group_id
  openvpn_vpc_private_subnet_1_id = module.vpc.openvpn_vpc_private_subnet_1_id
  openvpn_vpc_public_subnet_1_id  = module.vpc.openvpn_vpc_public_subnet_1_id
}

# module "openvpn_alb" {
#   source = "./openvpn/alb"

#   openvpn_vpc_id                 = module.vpc.openvpn_vpc_id
#   openvpn_alb_sg_id              = module.vpc.openvpn_alb_security_group_id
#   openvpn_admin_ip_whitelist     = var.openvpn_admin_ip_whitelist
#   openvpn_vpc_public_subnet_1_id = module.vpc.openvpn_vpc_public_subnet_1_id
#   openvpn_vpc_public_subnet_2_id = module.vpc.openvpn_vpc_public_subnet_2_id
# }
