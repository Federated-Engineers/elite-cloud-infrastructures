resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.federated-engineers-vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private-rtb.id]

  tags = merge(local.common_tags, { Name : "s3-vpc-endpoint" })
}
