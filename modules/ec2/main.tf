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
  for_each = toset(var.private_subnet_CIDR)

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ec2_instance_type
  subnet_id              = element(var.private_subnet_id, index(var.private_subnet_CIDR, each.key))
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name               = var.ec2_key_pair

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
service systemctl enable httpd
echo "<html><body bgcolor=black><center><h1><p><font color=gold>Web Server 1</h1></center></body></html>" > /var/www/html/index.html
EOF

  tags = { Name = join("-", ["Server", element(reverse(split("-", each.value)), 0)]) }
}
