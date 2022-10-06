# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "project-terraform-vpc-subnets-alb"
    key     = "vpc-project.tfstate"
    region  = "eu-west-2"
  }
}