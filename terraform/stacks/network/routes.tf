##
## Internet Gateway Route Table
##
resource "aws_route_table" "ig" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route" "ig_gw" {
  route_table_id         = aws_route_table.ig.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
  depends_on = [
    aws_route_table.ig,
    aws_internet_gateway.primary
  ]
}


##
## NAT Route Table
##
resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "NAT"
  }
}

resource "aws_route" "nat_gw" {
  route_table_id         = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.primary.id
  depends_on = [
    aws_route_table.nat,
    aws_nat_gateway.primary
  ]
}


##
## Route Table Associations
##

# Main Table
resource "aws_main_route_table_association" "primary" {
  vpc_id         = aws_vpc.primary.id
  route_table_id = aws_route_table.nat.id
}


# Per-Subnet Associations
resource "aws_route_table_association" "admin" {
  subnet_id      = aws_subnet.admin.id
  route_table_id = aws_route_table.ig.id
}

resource "aws_route_table_association" "public_edge_a" {
  subnet_id      = aws_subnet.public_edge_a.id
  route_table_id = aws_route_table.ig.id
}

resource "aws_route_table_association" "public_edge_b" {
  subnet_id      = aws_subnet.public_edge_b.id
  route_table_id = aws_route_table.ig.id
}

resource "aws_route_table_association" "public_edge_c" {
  subnet_id      = aws_subnet.public_edge_c.id
  route_table_id = aws_route_table.ig.id
}

resource "aws_route_table_association" "dmz_a" {
  subnet_id      = aws_subnet.dmz_a.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table_association" "dmz_b" {
  subnet_id      = aws_subnet.dmz_b.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table_association" "dmz_c" {
  subnet_id      = aws_subnet.dmz_c.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table_association" "internal_a" {
  subnet_id      = aws_subnet.internal_a.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table_association" "internal_b" {
  subnet_id      = aws_subnet.internal_b.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_route_table_association" "internal_c" {
  subnet_id      = aws_subnet.internal_c.id
  route_table_id = aws_route_table.nat.id
}
