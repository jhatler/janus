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
  default_tags {
    tags = {
      Kernel     = var.kernel
      Owner      = var.kernel_owner
      Repository = var.kernel_repository
      Branch     = var.kernel_branch
      Namespace  = var.kernel_namespace
      Registry   = var.kernel_registry
    }
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "test-${uuid()}"
  public_key = tls_private_key.example.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "aws_subnet" "example" {
  tags = {
    Name   = "Test Harness Subnet"
    Kernel = var.kernel
  }
}

data "aws_security_group" "example" {
  tags = {
    Name   = "Test Harness Default Security Group - Allow All"
    Kernel = var.kernel
  }
}

module "example" {
  source    = "../../"
  providers = { aws = aws }

  name          = "runner-example-${uuid()}"
  instance_type = "t3.medium"

  image_id = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.generated_key.key_name

  iam_instance_profile_name = "test-harness-ssm-agent"

  security_groups = [
    data.aws_security_group.example.id
  ]

  subnet_id = data.aws_subnet.example.id

  tags = {
    Name  = "runner-example-${uuid()}"
    Class = "Test:runner-${uuid()}"
  }
}
