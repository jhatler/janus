# Simple Usage

This is a simple example of using the example module to create a runner template based on Ubuntu 22.04.

```hcl
# Generate a new RSA key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Provide the public key to AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "test-${uuid()}"
  public_key = tls_private_key.example.public_key_openssh
}

# Get the latest Ubuntu 22.04 AMI
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

# Get a subnet to deploy the runner into
data "aws_subnet" "example" {
  tags = {
    Name   = "Test Harness Subnet"
    Kernel = var.kernel
  }
}

# Get a security group to allow all traffic
data "aws_security_group" "example" {
  name = "Test Harness Default Security Group - Allow All"
  tags = {
    Kernel = var.kernel
  }
}

# Create a runner based on the example module
module "example" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-runner-template/aws"
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
```
