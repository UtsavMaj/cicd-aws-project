# infrastructure/terraform/main.tf

terraform {
  required_version = ">= 1.7.0"
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

module "s3" {
  source       = "./modules/s3"
  bucket_name  = "cicd-tf-state-kushagra"   # change to your name
  project_name = var.project_name
}

module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  region       = var.region
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "ec2" {
  source                   = "./modules/ec2"
  project_name             = var.project_name
  vpc_id                   = module.vpc.vpc_id
  public_subnet_id         = module.vpc.public_subnet_ids[0]
  jenkins_instance_profile = module.iam.jenkins_instance_profile_name
  instance_type            = var.jenkins_instance_type
  key_name                 = "cicd-aws-key"   # must match your AWS key pair name
  your_ip                  = var.your_ip
  depends_on               = [module.vpc, module.iam]
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "eks" {
  source               = "./modules/eks"
  project_name         = var.project_name
  cluster_version      = var.eks_cluster_version
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
  private_subnet_ids   = module.vpc.private_subnet_ids
  depends_on           = [module.vpc, module.iam]
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_instance_class = var.rds_instance_class
  eks_node_sg_id     = module.ec2.jenkins_sg_id
  db_password        = "ChangeMeSecure123!"   # use terraform.tfvars or env var in real usage
  depends_on         = [module.vpc]
}