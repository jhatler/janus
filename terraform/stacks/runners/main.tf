# Common Security Group for the runners
resource "aws_security_group" "runners" {
  #checkov:skip=CKV2_AWS_5: This will be addressed in a future PR
  name = "runners"

  description = "Allow access to the GitHub Actions Runners"
  vpc_id      = var.vpc_id

  tags = {
    Name = "runners"
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

# All runners can go in the same subnet
data "aws_subnet" "dmz" {
  vpc_id = var.vpc_id

  tags = {
    Name = "DMZ A"
  }
}

# Retrieve the latest AMIs for the runners built by the CI pipeline
data "aws_ami" "runner_amd64" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^runner-amd64 .*$"
}

data "aws_ami" "runner_arm64" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^runner-arm64 .*$"
}

# Create SSH Keypair for the runners
resource "tls_private_key" "runners" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "runners" {
  key_name   = "runners"
  public_key = tls_private_key.runners.public_key_openssh
}

module "runner_template_arm64" {
  #checkov:skip=CKV_TF_1: Spacelift modules should be retrieved from Spacelift Module Registry
  source  = "spacelift.io/jhatler/runner-template/aws"
  version = "0.2.0"

  name          = "runner-arm64"
  instance_type = "c7g.medium"

  image_id = data.aws_ami.runner_arm64.id
  key_name = aws_key_pair.runners.key_name

  iam_instance_profile_name = "runners"

  security_groups = [
    aws_security_group.runners.id
  ]

  subnet_id = data.aws_subnet.dmz.id
  tags = {
    Name    = "runner-arm64"
    "class" = "runner"
  }
}


module "runner_template_amd64" {
  #checkov:skip=CKV_TF_1: Spacelift modules should be retrieved from Spacelift Module Registry
  source  = "spacelift.io/jhatler/runner-template/aws"
  version = "0.2.0"

  name          = "runner-amd64"
  instance_type = "c7a.medium"

  image_id = data.aws_ami.runner_amd64.id
  key_name = aws_key_pair.runners.key_name

  iam_instance_profile_name = "runners"

  security_groups = [
    aws_security_group.runners.id
  ]

  subnet_id = data.aws_subnet.dmz.id
  tags = {
    Name    = "runner-amd64"
    "class" = "runner"
  }
}
