##
## Public ACLs
##
locals {
  public_ingress_deny_ports = [
    20,
    21,
    22,
    3389
  ]
}

resource "aws_network_acl" "public_edge" {
  #checkov:skip=CKV2_AWS_1: ACLs used for network segmentation, so this is not applicable
  vpc_id = aws_vpc.primary.id

  subnet_ids = [
    aws_subnet.admin.id,
    aws_subnet.public_edge_a.id,
    aws_subnet.public_edge_b.id,
    aws_subnet.public_edge_c.id
  ]

  tags = {
    Name = "Public Edge"
  }
}

resource "aws_network_acl_rule" "public_edge_egress" {
  network_acl_id = aws_network_acl.public_edge.id

  egress = true

  protocol    = "-1"
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "public_edge_ingress_deny" {
  count          = length(local.public_ingress_deny_ports)
  network_acl_id = aws_network_acl.public_edge.id

  protocol    = "6"
  rule_number = 100 + (count.index * 10)
  rule_action = "deny"
  cidr_block  = "0.0.0.0/0"
  from_port   = local.public_ingress_deny_ports[count.index]
  to_port     = local.public_ingress_deny_ports[count.index]
}

resource "aws_network_acl_rule" "public_edge_ingress_allow" {
  #checkov:skip=CKV_AWS_352: Broad ingress is required for public edge, and mitigated above
  #checkov:skip=CKV_AWS_229: Port 21 is blocked above
  #checkov:skip=CKV_AWS_230: Port 20 is blocked above
  #checkov:skip=CKV_AWS_231: Port 3389 is blocked above
  #checkov:skip=CKV_AWS_232: Port 22 is blocked above
  network_acl_id = aws_network_acl.public_edge.id

  protocol    = "-1"
  rule_number = 32766
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}


##
## DMZ ACLs
##
resource "aws_network_acl" "dmz" {
  #checkov:skip=CKV2_AWS_1: ACLs used for network segmentation, so this is not applicable
  vpc_id = aws_vpc.primary.id

  subnet_ids = [
    aws_subnet.dmz_a.id,
    aws_subnet.dmz_b.id,
    aws_subnet.dmz_c.id
  ]

  tags = {
    Name = "DMZ"
  }
}

resource "aws_network_acl_rule" "dmz_egress" {
  network_acl_id = aws_network_acl.dmz.id

  egress = true

  protocol    = "-1"
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "dmz_ingress_admin" {
  #checkov:skip=CKV_AWS_352: Admin subnet should not be restricted
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "-1"
  rule_number = 50
  rule_action = "allow"
  cidr_block  = aws_subnet.admin.cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "dmz_ingress_icmp" {
  #checkov:skip=CKV_AWS_352: DO NOT BLOCK ICMP!!! shouldiblockicmp.com
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "icmp"
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  icmp_code   = -1
  icmp_type   = -1
}

resource "aws_network_acl_rule" "dmz_ingress_mysql" {
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "6"
  rule_number = 200
  rule_action = "deny"
  cidr_block  = "0.0.0.0/0"
  from_port   = 3389
  to_port     = 3389
}

resource "aws_network_acl_rule" "dmz_ingress_public_edge" {
  #checkov:skip=CKV_AWS_352: All ports OK from public edge to DMZ
  count          = length(aws_subnet.public_edge[*].cidr_block)
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "-1"
  rule_number = 300 + (count.index * 10)
  rule_action = "allow"
  cidr_block  = aws_subnet.public_edge[count.index].cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "dmz_ingress_dmz" {
  #checkov:skip=CKV_AWS_352: All ports OK within DMZ
  count          = length(aws_subnet.dmz[*].cidr_block)
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "-1"
  rule_number = 400 + (count.index * 10)
  rule_action = "allow"
  cidr_block  = aws_subnet.dmz[count.index].cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "dmz_ingress_internal" {
  #checkov:skip=CKV_AWS_352: All ports OK from internal to DMZ
  count          = length(aws_subnet.internal[*].cidr_block)
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "-1"
  rule_number = 500 + (count.index * 10)
  rule_action = "allow"
  cidr_block  = aws_subnet.internal[count.index].cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "dmz_ingress_ephemeral" {
  #checkov:skip=CKV_AWS_231: Port 3389 is blocked above
  network_acl_id = aws_network_acl.dmz.id

  protocol    = "6"
  rule_number = 32766
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}

##
## Internal ACLs
##
resource "aws_network_acl" "internal" {
  #checkov:skip=CKV2_AWS_1: ACLs used for network segmentation, so this is not applicable
  vpc_id = aws_vpc.primary.id

  subnet_ids = [
    aws_subnet.internal_a.id,
    aws_subnet.internal_b.id,
    aws_subnet.internal_c.id
  ]

  tags = {
    Name = "Internal"
  }
}

resource "aws_network_acl_rule" "internal_egress" {
  network_acl_id = aws_network_acl.internal.id

  egress = true

  protocol    = "-1"
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "internal_ingress_admin" {
  #checkov:skip=CKV_AWS_352: Admin subnet should not be restricted
  network_acl_id = aws_network_acl.internal.id

  protocol    = "-1"
  rule_number = 50
  rule_action = "allow"
  cidr_block  = aws_subnet.admin.cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "internal_ingress_icmp" {
  #checkov:skip=CKV_AWS_352: DO NOT BLOCK ICMP!!! shouldiblockicmp.com
  network_acl_id = aws_network_acl.internal.id

  protocol    = "icmp"
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  icmp_code   = -1
  icmp_type   = -1
}

resource "aws_network_acl_rule" "internal_ingress_mysql" {
  network_acl_id = aws_network_acl.internal.id

  protocol    = "6"
  rule_number = 200
  rule_action = "deny"
  cidr_block  = "0.0.0.0/0"
  from_port   = 3389
  to_port     = 3389
}

resource "aws_network_acl_rule" "internal_ingress_dmz" {
  #checkov:skip=CKV_AWS_352: All ports OK from dmz to internal
  count          = length(aws_subnet.dmz[*].cidr_block)
  network_acl_id = aws_network_acl.internal.id

  protocol    = "-1"
  rule_number = 300 + (count.index * 10)
  rule_action = "allow"
  cidr_block  = aws_subnet.dmz[count.index].cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "internal_ingress_internal" {
  #checkov:skip=CKV_AWS_352: All ports within internal
  count          = length(aws_subnet.internal[*].cidr_block)
  network_acl_id = aws_network_acl.internal.id

  protocol    = "-1"
  rule_number = 400 + (count.index * 10)
  rule_action = "allow"
  cidr_block  = aws_subnet.internal[count.index].cidr_block
  from_port   = 0
  to_port     = 0
  icmp_code   = 0
  icmp_type   = 0
}

resource "aws_network_acl_rule" "internal_ingress_ephemeral" {
  #checkov:skip=CKV_AWS_231: Port 3389 is blocked above
  network_acl_id = aws_network_acl.internal.id

  protocol    = "6"
  rule_number = 32766
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}
