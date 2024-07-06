# Runner Template Module

This module creates an EC2 Launch Template for creating runners. It supports the following features:

- AMI Specification
- IAM Instance Profile Specification
- Instance Type Specification
- SSH Key Pair Specification
- Tagging
- Root Volume Size Specification
- Network Specifications
  - Security Groups
  - Subnet
  - Public IP Address Assignment

## Usage

```hcl
data "aws_key_pair" "example" {
  key_name           = "example"
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

  owners = ["099720109477"] # Canonical
}

data "aws_subnet" "example" {
  tags = {
    Name = "example"
  }
}

data "aws_security_group" "example" {
  name = "example"
}

module "runner_template" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-runner-template/aws"
  providers = { aws = aws }

  name          = "runner-example"
  instance_type = "t3.medium"

  image_id = data.aws_ami.ubuntu.id
  key_name = data.aws_key_pair.example.key_name

  iam_instance_profile_name = "runner-example"

  security_groups = [
    data.aws_security_group.example.id
  ]

  subnet_id = data.aws_subnet.example.id

  tags = {
    Name  = "runner-example"
    Class = "runner"
  }
}
```
