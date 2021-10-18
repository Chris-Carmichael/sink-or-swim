# VPC
module "vpc" {
  source = "../modules/terraform-aws-vpc"

  name = var.solution_name
  cidr = var.vpc_cidr

  azs             = [var.az_1, var.az_2]
  private_subnets = [var.private_cidr_1, var.private_cidr_2]
  public_subnets  = [var.public_cidr_1, var.public_cidr_2]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

## providers and backend config
terraform {
  # https://www.terraform.io/docs/language/settings/backends/s3.html
  backend "s3" {
    bucket         = "terraform-state-creature"
    encrypt        = true
    key            = "vpc"
    region         = "us-west-2"
    dynamodb_table = "tfstate-lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "terraform_locks" {
  
  name         = "tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

}
