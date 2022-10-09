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
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# public subnets configuration
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_CIDR)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.public_subnet_CIDR, each.key))
  cidr_block              = each.key
  map_public_ip_on_launch = true

  tags = { Name = join("-", ["public", element(reverse(split("-", each.value)), 0)]) }
}

# create route table and add public route
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_public_route
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# associate public subnets to "public route table"
resource "aws_route_table_association" "public" {
  for_each = toset(var.public_subnet_CIDR)

  subnet_id      = aws_subnet.public[each.value].id
  route_table_id = aws_route_table.public.id
}

# create private subnets
resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_CIDR)

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.private_subnet_CIDR, each.key))
  cidr_block              = each.key
  map_public_ip_on_launch = false

  tags = { Name = join("-", ["private", element(reverse(split("-", each.value)), 0)]) }
}

# allocate elastic ip
# eip will be used for the nat-gateway in the public subnets
resource "aws_eip" "nat" {
  vpc  = true
  tags = { Name = "nat" }
}

# create nat gateway in public subnets
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[element(var.public_subnet_CIDR, 1)].id

  tags = { Name = "ngw" }
}

# create private route table and add route through nat gateway 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = { Name = "private" }
}

# associate private subnets with private route table
resource "aws_route_table_association" "private" {
  for_each       = toset(var.private_subnet_CIDR)

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[each.value].id
}






