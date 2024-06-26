##
## VPC and Misc. Resources
##
resource "aws_vpc" "primary" {
  cidr_block       = "${var.class_b_prefix}.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Primary VPC"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Default Rule - Deny All"
  }
}

resource "aws_flow_log" "primary_cloudwatch" {
  iam_role_arn    = var.vpc_flow_role_arn
  log_destination = aws_cloudwatch_log_group.vpc_flow.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.primary.id
}

resource "aws_flow_log" "primary_s3" {
  log_destination      = aws_s3_bucket.vpc_flow.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.primary.id
}

# Primary VPC default ACL
resource "aws_default_network_acl" "primary" {
  default_network_acl_id = aws_vpc.primary.default_network_acl_id

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


# Primary VPC Internet Gateway
resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Primary-IG"
  }
}


# Primary VPC DHCP Options
resource "aws_vpc_dhcp_options" "primary" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "Default DHCP Options"
  }
}

resource "aws_vpc_dhcp_options_association" "primary" {
  vpc_id          = aws_vpc.primary.id
  dhcp_options_id = aws_vpc_dhcp_options.primary.id
}


# Primary VPC NAT Gateway
resource "aws_nat_gateway" "primary" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.admin.id

  tags = {
    Name = "Primary NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.primary]
}
