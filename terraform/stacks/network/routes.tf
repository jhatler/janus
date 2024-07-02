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
## Admin Route Table
##
resource "aws_route_table" "admin" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Admin"
  }
}

resource "aws_route" "admin_gw" {
  route_table_id         = aws_route_table.admin.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
  depends_on = [
    aws_route_table.admin,
    aws_internet_gateway.primary
  ]
}


##
## Route Table Associations
##

# Main Table
resource "aws_main_route_table_association" "primary" {
  route_table_id = aws_route_table.nat.id
  vpc_id         = aws_vpc.primary.id
}

# Per-Subnet Associations
resource "aws_route_table_association" "admin" {
  route_table_id = aws_route_table.admin.id
  subnet_id      = aws_subnet.admin.id
}

resource "aws_route_table_association" "public_edge" {
  count = length(aws_subnet.public_edge[*].id)

  route_table_id = aws_route_table.ig.id
  subnet_id      = aws_subnet.public_edge[count.index].id
}

resource "aws_route_table_association" "dmz" {
  count = length(aws_subnet.dmz[*].id)

  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.dmz[count.index].id
}

resource "aws_route_table_association" "internal" {
  count = length(aws_subnet.internal[*].id)

  route_table_id = aws_route_table.nat.id
  subnet_id      = aws_subnet.internal[count.index].id
}
