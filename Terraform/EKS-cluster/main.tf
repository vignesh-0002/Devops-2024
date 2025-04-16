# main.tf
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b"]
}

module "eks" {
  source              = "./eks"
  cluster_name        = "my-eks-cluster"
  eks_role_arn        = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  subnet_ids          = module.vpc.public_subnets
  eks_security_group  = module.vpc.eks_security_group
}
