data "aws_availability_zones" "available" {
  state = "available"
}

##
## Public Subnets
##
resource "aws_subnet" "admin" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.0.0/22"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Admin"
  }
}

resource "aws_subnet" "public_edge_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.16.0/22"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Public Edge A"
  }
}

resource "aws_subnet" "public_edge_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.20.0/22"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Public Edge B"
  }
}

resource "aws_subnet" "public_edge_c" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.24.0/22"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "Public Edge C"
  }
}


##
## DMZ Subnets
##
resource "aws_subnet" "dmz_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.80.0/22"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "DMZ A"
  }
}

resource "aws_subnet" "dmz_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.84.0/22"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "DMZ B"
  }
}

resource "aws_subnet" "dmz_c" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.88.0/22"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "DMZ C"
  }
}


##
## Public Subnets
##
resource "aws_subnet" "internal_a" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.160.0/22"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Internal A"
  }
}

resource "aws_subnet" "internal_b" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.164.0/22"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Internal B"
  }
}

resource "aws_subnet" "internal_c" {
  vpc_id = aws_vpc.primary.id

  cidr_block        = "10.24.168.0/22"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "Internal C"
  }
}
