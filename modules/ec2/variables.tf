variable "ec2_security_group_id" {}
variable "vpc_id" {}
variable "private_subnet_id" {}

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

variable "instances" {
  type = map
  default = {
    server = {
      ami           = "ami-06672d07f62285d1d"
      instance_type = "t2.micro"
    }
  }
}
