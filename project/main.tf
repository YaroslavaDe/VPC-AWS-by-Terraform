# configure aws provider
provider "aws" {
  region = var.region
}

# create vpc
module "vpc" {
  source              = "../modules/vpc"
  region              = var.region
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_CIDR  = var.public_subnet_CIDR
  private_subnet_CIDR = var.private_subnet_CIDR
}

# create security group
module "security_group" {
  source       = "../modules/security-groups"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}
