data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "eks" {
  source = "../modules/terraform-aws-eks"

  cluster_version                      = var.cluster_version
  cluster_name                         = var.solution_name
  vpc_id                               = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets                              = data.terraform_remote_state.vpc.outputs.private_subnets
  cluster_endpoint_public_access_cidrs = [local.external-cidr]
  worker_ami_name_filter               = var.worker_ami_name_filter
  worker_ami_owner_id                  = var.worker_ami_owner_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = var.instance_type
      asg_desired_capacity = 2
      asg_max_size         = 2

      tags = [{
        key                 = "ExtraTag"
        value               = "TagValue"
        propagate_at_launch = true
      }]
    }
  ]
}

## providers and backend config

terraform {
  # https://www.terraform.io/docs/language/settings/backends/s3.html
  backend "s3" {
    bucket         = "terraform-state-creature"
    key            = "eks"
    region         = "us-west-2"
    dynamodb_table = "tfstate-lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "http" {}

## Remote State(s)

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "terraform-state-creature"
    key            = "vpc"
    region         = "us-west-2"
    dynamodb_table = "tfstate-lock"
  }
}
