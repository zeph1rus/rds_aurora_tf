resource "aws_vpc" "rgtsdbvpc" {
  cidr_block = "10.20.0.0/16"
  tags = {
    "environment" = "dev"
    "name"        = "rgtsdbvpc"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "rgtsdbsubnet_az1" {
  count                   = length(var.az1_subnet_cidrs)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.rgtsdbvpc.id
  cidr_block              = var.az1_subnet_cidrs[count.index]
  availability_zone       = "us-east-1a"
  tags                    = var.tags
}


resource "aws_subnet" "rgtsdbsubnet_az2" {
  count                   = length(var.az2_subnet_cidrs)
  map_public_ip_on_launch = true

  vpc_id            = aws_vpc.rgtsdbvpc.id
  cidr_block        = var.az2_subnet_cidrs[count.index]
  availability_zone = "us-east-1b"
  tags              = var.tags
}

resource "aws_internet_gateway" "rgtsdbigw" {
  vpc_id = aws_vpc.rgtsdbvpc.id
  tags   = var.tags
}

resource "aws_route_table" "rgtsdbrt" {
  vpc_id = aws_vpc.rgtsdbvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rgtsdbigw.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "rgtsdbrtaz1" {
  count          = length(aws_subnet.rgtsdbsubnet_az1)
  subnet_id      = aws_subnet.rgtsdbsubnet_az1[count.index].id
  route_table_id = aws_route_table.rgtsdbrt.id
  depends_on     = [aws_route_table.rgtsdbrt]
}

resource "aws_route_table_association" "rgtsdbrtaz2" {
  count          = length(aws_subnet.rgtsdbsubnet_az2)
  subnet_id      = aws_subnet.rgtsdbsubnet_az2[count.index].id
  route_table_id = aws_route_table.rgtsdbrt.id
  depends_on     = [aws_route_table.rgtsdbrt]
}

resource "aws_security_group" "db_security_group" {
  name   = "rgtsdbsecuritygroup"
  vpc_id = aws_vpc.rgtsdbvpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "db_security_group_rule_inbound" {
  security_group_id = aws_security_group.db_security_group.id
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}