variable "ec2_security_group_id" {}
variable "vpc_id" {}
variable "private_subnet_id" {}
variable "private_subnet_CIDR" {}

variable "ec2_key_pair" {
  description = "AWS ec2 key pair"
  type        = string
  default     = "ssh_project"
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t2.micro"
}
