resource "aws_default_vpc" "current" {}

data "aws_vpc" "primary" {
  filter {
    name   = "tag:Name"
    values = ["Primary VPC"]
  }
}

resource "aws_security_group" "runner" {
  name        = "runner"
  description = "Allow access to the GitHub Actions Runners"
  vpc_id      = data.aws_vpc.primary.id

  tags = {
    Name = "runner"
  }

  ingress = []

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}
