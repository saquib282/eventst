provider "aws" {
    region = var.aws_region 
}

locals {
  cluster_name = "eventstrat-cluster"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  single_nat_gateway = true
  enable_nat_gateway = true

    tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

    public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = local.cluster_name
  cluster_version= var.cluster_version

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    defaults = {
        instance_types = var.instance_types
        min_size = 2
        max_size = 3
        desired_size = 2
    }
  }
}
