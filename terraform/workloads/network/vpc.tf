##
## VPC and Misc. Resources
##
resource "aws_vpc" "kernel" {
  cidr_block       = "${var.kernel_cidr_prefix}.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Kernel"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.kernel.id

  tags = {
    Name = "Default Rule - Deny All"
  }
}

resource "aws_flow_log" "kernel_cloudwatch" {
  iam_role_arn    = var.vpc_flow_role_arn
  log_destination = aws_cloudwatch_log_group.vpc_flow.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.kernel.id
}

resource "aws_flow_log" "kernel_s3" {
  log_destination      = module.s3_vpc_flow.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.kernel.id
}

# kernel VPC default ACL
resource "aws_default_network_acl" "kernel" {
  default_network_acl_id = aws_vpc.kernel.default_network_acl_id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "Default ACL"
  }
}


# kernel VPC Internet Gateway
resource "aws_internet_gateway" "kernel" {
  vpc_id = aws_vpc.kernel.id

  tags = {
    Name = "Kernel IG"
  }
}


# kernel VPC DHCP Options
resource "aws_vpc_dhcp_options" "kernel" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "Default DHCP Options"
  }
}

resource "aws_vpc_dhcp_options_association" "kernel" {
  vpc_id          = aws_vpc.kernel.id
  dhcp_options_id = aws_vpc_dhcp_options.kernel.id
}


# kernel VPC NAT Gateway
resource "aws_nat_gateway" "kernel" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.admin.id

  tags = {
    Name = "Kernel NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.kernel]
}
