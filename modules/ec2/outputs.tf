output "instance_alb" {
  value = values(aws_instance.server)[*].id
}