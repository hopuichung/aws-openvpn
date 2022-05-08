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
  region  = "ap-east-1"
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
    subscriber_email_addresses = [""]
  }
}