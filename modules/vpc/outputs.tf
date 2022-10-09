output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "internet_gateway" {
  value = aws_internet_gateway.this
}

output "public_subnet_id" {
  value = values(aws_subnet.public)[*].id
  
}
output "private_subnet_id" {
  value = values(aws_subnet.private)[*].id
} 