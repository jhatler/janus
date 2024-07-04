terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "runner-test"
  public_key = tls_private_key.example.public_key_openssh
}

data "aws_vpc" "primary" {
  tags = {
    Name = "Primary VPC"
  }
}

data "aws_subnet" "dmz" {
  vpc_id = data.aws_vpc.primary.id

  tags = {
    Name = "DMZ A"
  }
}

resource "aws_security_group" "runner_test" {
  name = "runner-test"

  description = "Allow access to the GitHub Actions Runners"
  vpc_id      = data.aws_vpc.primary.id

  tags = {
    Name = "runner-test"
  }

  ingress = []

  egress {
    description = "Allow all outbound traffic via IPv4"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic via IPv6"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}


module "example" {
  source = "../../"

  name          = "runner-example"
  instance_type = "c7a.medium"

  image_id = "ami-0f30a9c3a48f3fa79"
  key_name = aws_key_pair.generated_key.key_name

  iam_instance_profile_name = "ssm-agent"

  security_groups = [
    aws_security_group.runner_test.id
  ]

  subnet_id = data.aws_subnet.dmz.id

  tags = {
    Name    = "runner-example"
    "class" = "runner"
  }
}
