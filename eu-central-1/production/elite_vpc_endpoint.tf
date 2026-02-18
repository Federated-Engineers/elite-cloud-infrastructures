resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.elite-vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.public-subnet-rtb.id]

  tags = merge(local.common_tags, { Name : "elite-vpc-public-subnet-rtb" })
}