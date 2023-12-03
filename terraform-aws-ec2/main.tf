terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_default_vpc" "default" {}

data "aws_ami" "default" {
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

resource "aws_instance" "default" {
  depends_on    = [aws_default_vpc.default]
  ami           = data.aws_ami.default.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

# variable.tf
variable "instance_type" {
  description = "vm 인스턴스 타입 정의"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "vm 인스턴스 이름 정의"
  default     = "my_ec2"
}

# output.tf
output "private_ip" {
  value = aws_instance.default.private_ip
}
