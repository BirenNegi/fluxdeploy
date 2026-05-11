terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "iam" {
  source = "../../modules/iam"

  project     = var.project
  environment = var.environment
}

module "ecr" {
  source = "../../modules/ecr"

  project     = var.project
  environment = var.environment
}

module "eks" {
  source = "../../modules/eks"

  project                 = var.project
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
  node_instance_type      = var.node_instance_type
  node_desired_size       = var.node_desired_size
  node_min_size           = var.node_min_size
  node_max_size           = var.node_max_size
}

module "rds" {
  source = "../../modules/rds"

  project               = var.project
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_password           = var.db_password
  eks_security_group_id = module.eks.eks_nodes_security_group_id
}