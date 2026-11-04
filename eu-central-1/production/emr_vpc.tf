resource "aws_vpc" "emr" {
  cidr_block           = "10.30.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, { Name = "elite-emr-vpc" })
}

resource "aws_internet_gateway" "emr" {
  vpc_id = aws_vpc.emr.id

  tags = merge(local.common_tags, { Name = "elite-emr-igw" })
}

resource "aws_subnet" "emr_public" {
  for_each = {
    a = "10.30.0.0/20"
    b = "10.30.16.0/20"
    c = "10.30.32.0/20"
  }

  vpc_id                  = aws_vpc.emr.id
  cidr_block              = each.value
  availability_zone       = "eu-central-1${each.key}"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                                       = "elite-emr-public-${each.key}"
    "for-use-with-amazon-emr-managed-policies" = "true"
  })
}

resource "aws_route_table" "emr_public" {
  vpc_id = aws_vpc.emr.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.emr.id
  }

  tags = merge(local.common_tags, { Name = "elite-emr-public-rt" })
}

resource "aws_route_table_association" "emr_public" {
  for_each = aws_subnet.emr_public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.emr_public.id
}

resource "aws_vpc_endpoint" "emr_s3" {
  vpc_id            = aws_vpc.emr.id
  service_name      = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.emr_public.id]

  tags = merge(local.common_tags, { Name = "elite-emr-s3-endpoint" })
}
