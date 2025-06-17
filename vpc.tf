terraform {
    backend "s3" {
      bucket = "my-app-tfstatebucket"
      key = "my-app/state.tfstate"
      region = "ap-southeast-1"
    }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "azs" {}

resource "random_string" "suffix" {
    length = 8
    special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
     "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
     "kubernetes.io/role/internal-elb" = 1
  }
}