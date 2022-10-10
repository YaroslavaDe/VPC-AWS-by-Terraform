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

# launch ec2 instances in private subnet
module "ec2" {
  source                = "../modules/ec2"
  vpc_id                = module.vpc.vpc_id
  ec2_security_group_id = module.security_group.ec2_security_group_id
  private_subnet_id     = module.vpc.private_subnet_id
  private_subnet_CIDR   = var.private_subnet_CIDR

  depends_on = [module.vpc]

}

module "application_load_balancer" {
  source                = "../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  vpc_id                = module.vpc.vpc_id
  instance_alb          = module.ec2.instance_alb
  public_subnet_id      = module.vpc.public_subnet_id
  private_subnet_CIDR   = var.private_subnet_CIDR
}

