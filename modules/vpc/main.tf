# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# public subnets configuration
resource "aws_subnet" "public_subnet" {
  for_each                = toset(var.public_subnet_CIDR)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.public_subnet_CIDR, each.key))
  cidr_block              = each.key
  map_public_ip_on_launch = true

  tags = { Name = join("-", ["public", element(reverse(split("-", each.value)), 0)]) }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_public_route
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# associate public subnets to "public route table"
resource "aws_route_table_association" "public_subnet_route_table_association" {
  for_each       = toset(var.public_subnet_CIDR)
  subnet_id      = aws_subnet.public_subnet[each.value].id
  route_table_id = aws_route_table.public_route_table.id
}

# create private subnets
resource "aws_subnet" "private_subnet" {
  for_each                = toset(var.private_subnet_CIDR)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.private_subnet_CIDR, each.key))
  cidr_block              = each.key
  map_public_ip_on_launch = false

  tags = { Name = join("-", ["private", element(reverse(split("-", each.value)), 0)]) }
}




