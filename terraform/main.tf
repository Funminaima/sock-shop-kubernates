provider "aws" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "kubernates-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
#   enable_vpn_gateway = true
single_nat_gateway = true
enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "sockShop"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type="AL2023_x86_64_STANDARD"
   
  }

  eks_managed_node_groups = {
    node1 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    name="node1"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
   node2 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups

      name="node2"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true



  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}