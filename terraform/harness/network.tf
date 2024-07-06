resource "aws_vpc" "test" {
  cidr_block       = "${var.kernel_cidr_prefix}.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name  = "Test Harness VPC"
    Class = "Test"
  }
}

resource "aws_default_security_group" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name  = "Test Harness Default Security Group - Allow All"
    Class = "Test"
  }

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

  ingress {
    description = "Allow all inbound traffic via IPv4"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow all inbound traffic via IPv4"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_flow_log" "s3" {
  log_destination      = aws_s3_bucket.log_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.test.id
}

resource "aws_default_network_acl" "test" {
  default_network_acl_id = aws_vpc.test.default_network_acl_id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol        = "-1"
    rule_no         = 200
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol        = "-1"
    rule_no         = 200
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  tags = {
    Name  = "Test Harness Default ACL"
    Class = "Test"
  }
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name  = "Test Harness Internet Gateway"
    Class = "Test"
  }
}

resource "aws_vpc_dhcp_options" "test" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name  = "Default DHCP Options"
    Class = "Test"
  }
}

resource "aws_vpc_dhcp_options_association" "test" {
  vpc_id          = aws_vpc.test.id
  dhcp_options_id = aws_vpc_dhcp_options.test.id
}

resource "aws_default_route_table" "test" {
  default_route_table_id = aws_vpc.test.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }

  tags = {
    Name  = "Test Harness Default Route Table"
    Class = "Test"
  }
}

resource "aws_subnet" "test" {
  vpc_id = aws_vpc.test.id

  cidr_block        = "${var.kernel_cidr_prefix}.0.0/20"
  availability_zone = "${var.aws_default_region}a"

  tags = {
    Name  = "Test Harness Subnet"
    Class = "Test"
  }
}
