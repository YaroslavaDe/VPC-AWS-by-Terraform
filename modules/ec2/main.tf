# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# launch the ec2 instance in private subnet az1
resource "aws_instance" "server" {
  for_each = toset(var.private_subnet_id)

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ec2_instance_type
  subnet_id              = each.key
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name               = var.ec2_key_pair

  tags = {
    Name = "Server ${each.key}"
  }
}


