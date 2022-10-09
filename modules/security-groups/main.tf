resource "aws_security_group" "alb" {
  name        = "alb security group"
  description = "Allow http/https access on port 80/443"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports

    content {
      description = "http access"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks

    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb security group"
  }
}

# create security group for the ec2 instance
resource "aws_security_group" "ec2" {
  name        = "ec2 security group"
  description = "allow SSH access on port 22, 80"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ec2_ports

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2 security group"
  }
}
