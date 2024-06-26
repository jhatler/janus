data "aws_availability_zones" "available" {
  state = "available"
}

##
## Public Subnets
##
resource "aws_subnet" "admin" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.0.0/22"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Admin"
  }
}

resource "aws_subnet" "public_edge" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.${count.index * 4 + 16}.0/22"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public Edge ${upper(substr(data.aws_availability_zones.available.names[count.index], -1, 1))}"
  }
}

##
## NAT Subnets
##
resource "aws_subnet" "dmz" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.${count.index * 4 + 80}.0/22"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "DMZ ${upper(substr(data.aws_availability_zones.available.names[count.index], -1, 1))}"
  }
}

resource "aws_subnet" "internal" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.primary.id

  cidr_block        = "${var.class_b_prefix}.${count.index * 4 + 160}.0/22"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Internal ${upper(substr(data.aws_availability_zones.available.names[count.index], -1, 1))}"
  }
}
