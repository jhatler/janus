##
## Public ACLs
##
resource "aws_network_acl" "public_edge" {
  vpc_id = aws_vpc.primary.id

  subnet_ids = [
    aws_subnet.admin.id,
    aws_subnet.public_edge_a.id,
    aws_subnet.public_edge_b.id,
    aws_subnet.public_edge_c.id
  ]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "6"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 20
    to_port    = 20
  }

  ingress {
    protocol   = "6"
    rule_no    = 200
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 21
    to_port    = 21
  }

  ingress {
    protocol   = "6"
    rule_no    = 300
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "6"
    rule_no    = 400
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = "-1"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  tags = {
    Name = "Public Edge"
  }
}


##
## DMZ ACLs
##
resource "aws_network_acl" "dmz" {
  vpc_id = aws_vpc.primary.id

  subnet_ids = [
    aws_subnet.dmz_a.id,
    aws_subnet.dmz_b.id,
    aws_subnet.dmz_c.id
  ]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = -1
    icmp_type  = -1
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_edge_a.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.public_edge_b.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 300
    action     = "allow"
    cidr_block = aws_subnet.public_edge_c.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 400
    action     = "allow"
    cidr_block = aws_subnet.dmz_a.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 500
    action     = "allow"
    cidr_block = aws_subnet.dmz_b.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 600
    action     = "allow"
    cidr_block = aws_subnet.dmz_c.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }


  ingress {
    protocol   = "-1"
    rule_no    = 700
    action     = "allow"
    cidr_block = aws_subnet.internal_a.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 800
    action     = "allow"
    cidr_block = aws_subnet.internal_b.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 900
    action     = "allow"
    cidr_block = aws_subnet.internal_c.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 1000
    action     = "allow"
    cidr_block = aws_subnet.admin.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "6"
    rule_no    = 1100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = "6"
    rule_no    = 1200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    icmp_code  = 0
    icmp_type  = 0
  }

  tags = {
    Name = "DMZ"
  }
}

##
## Internal ACLs
##
resource "aws_network_acl" "internal" {
  vpc_id = aws_vpc.primary.id

  subnet_ids = [
    aws_subnet.internal_a.id,
    aws_subnet.internal_b.id,
    aws_subnet.internal_c.id
  ]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.dmz_a.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.dmz_b.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 300
    action     = "allow"
    cidr_block = aws_subnet.dmz_c.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }


  ingress {
    protocol   = "-1"
    rule_no    = 400
    action     = "allow"
    cidr_block = aws_subnet.internal_a.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 500
    action     = "allow"
    cidr_block = aws_subnet.internal_b.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 600
    action     = "allow"
    cidr_block = aws_subnet.internal_c.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 700
    action     = "allow"
    cidr_block = aws_subnet.admin.cidr_block
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  ingress {
    protocol   = "6"
    rule_no    = 900
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = "6"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    icmp_code  = 0
    icmp_type  = 0
  }

  tags = {
    Name = "Internal"
  }
}
