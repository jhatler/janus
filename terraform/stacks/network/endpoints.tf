resource "aws_security_group" "ecr_endpoints" {
  #ts:skip=AC_AWS_0229 This will be addressed in a future PR
  name = "ecr-endpoints"

  description = "Associated to ECR/S3 VPC Endpoints"
  vpc_id      = aws_vpc.primary.id

  ingress {
    description = "Allow Nodes to pull images from ECR via VPC endpoints"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.primary.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [aws_security_group.ecr_endpoints.id]
  subnet_ids         = aws_subnet.internal[*].id

  tags = {
    "Name" = "ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.primary.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [aws_security_group.ecr_endpoints.id]
  subnet_ids         = aws_subnet.internal[*].id

  tags = {
    "Name" = "ecr-api"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.primary.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.ig.id,
    aws_route_table.admin.id,
    aws_route_table.nat.id
  ]

  tags = {
    "Name" = "s3"
  }
}
