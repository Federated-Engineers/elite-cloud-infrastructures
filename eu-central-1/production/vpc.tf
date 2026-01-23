resource "aws_vpc" "federated-engineers-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, { Name : "secure-production" })
}

resource "aws_subnet" "private-subnet" {

  vpc_id            = aws_vpc.federated-engineers-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1a"

  tags = merge(local.common_tags, { Name : "secure-production-private" })
}

resource "aws_subnet" "public-subnet" {

  vpc_id                  = aws_vpc.federated-engineers-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, { Name : "secure-production-public" })
}

resource "aws_internet_gateway" "secure-production-igw" {
  vpc_id = aws_vpc.federated-engineers-vpc.id

  tags = merge(local.common_tags, { Name : "secure-production-igw" })
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.federated-engineers-vpc.id

  tags = merge(local.common_tags, { Name : "secure-production-private-rt" })
}

resource "aws_route_table_association" "private_subnet_associations" {

  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rtb.id
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.federated-engineers-vpc.id

  tags = merge(local.common_tags, { Name : "secure-production-public-rt" })
}

resource "aws_route_table_association" "public_subnet_associations" {

  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route" "public-route" {
  route_table_id            = aws_route_table.public-rtb.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.secure-production-igw.id
}

resource "aws_security_group" "secure-production-sg" {
  name        = "secure-production-sg"
  description = "Dedicated security group for the VPC"
  vpc_id      = aws_vpc.federated-engineers-vpc.id

  tags = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.secure-production-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol         = "-1"
}
