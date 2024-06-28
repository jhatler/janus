resource "aws_security_group" "runner" {
  #checkov:skip=CKV2_AWS_5: This will be addressed in a future PR
  name = "runner"

  description = "Allow access to the GitHub Actions Runners"
  vpc_id      = var.vpc_id

  tags = {
    Name = "runner"
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
