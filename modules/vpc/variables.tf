variable "region" {}
variable "project_name" {}

variable "vpc_cidr" {
  type = string
  description = "The CIDR block for the VPC"
}

variable "cidr_public_route" {
  description = "The CIDR block for the VPC"
  default     = "0.0.0.0/0"
}

variable "public_route_table_name" {
  type    = string
  default = "public route table"
}

variable "public_subnet_CIDR" {
  type    = list(string)
}

variable "private_subnet_CIDR" {
  type    = list(string)
}
