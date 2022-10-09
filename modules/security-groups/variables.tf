variable "vpc_id" {}
variable "project_name" {}

variable "allowed_ports" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  
  default = {
    "80" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "443" = {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}
