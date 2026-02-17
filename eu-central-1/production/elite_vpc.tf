resource "aws_vpc" "elite-vpc" {
    cidr_block           = "172.16.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
  Name = "elite-vpc"
}
}

resource "aws_subnet" "public-subnet-a" {
    vpc_id = aws_vpc.elite-vpc.id
    cidr_block =  "172.16.0.0/19"
    availability_zone = "eu-central-1a"

    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet-a" {
    vpc_id = aws_vpc.elite-vpc.id
    cidr_block =  "172.16.32.0/19"
    availability_zone = "eu-central-1a"
}

resource "aws_subnet" "public-subnet-b" {
    vpc_id = aws_vpc.elite-vpc.id
    cidr_block =  "172.16.64.0/19"
    availability_zone = "eu-central-1b"

    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet-b" {
    vpc_id = aws_vpc.elite-vpc.id
    cidr_block =  "172.16.96.0/19"
    availability_zone = "eu-central-1b"
}

resource "aws_subnet" "public-subnet-c" {
    vpc_id = aws_vpc.elite-vpc.id
    cidr_block =  "172.16.128.0/18"
    availability_zone = "eu-central-1c"

    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-subnet-c" {
    vpc_id = aws_vpc.elite-vpc.id
    cidr_block =  "172.16.192.0/18"
    availability_zone = "eu-central-1c"
}

resource "aws_internet_gateway" "elite-gateway" {
    vpc_id = aws_vpc.elite-vpc.id
    
    tags = {
  Name = "elite-vpc-internet-gateway"
}

}

resource "aws_route_table" "public-subnet-rtb" {
    vpc_id = aws_vpc.elite-vpc.id
    tags = {
    Name = "elite-vpc-public-subnet-rtb"
  }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.elite-gateway.id
  }
}

resource "aws_route_table_association" "public-rtb-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-subnet-rtb.id
}

resource "aws_route_table_association" "public-rtb-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-subnet-rtb.id
}

resource "aws_route_table_association" "public-rtb-c" {
  subnet_id      = aws_subnet.public-subnet-c.id
  route_table_id = aws_route_table.public-subnet-rtb.id
}

resource "aws_route_table" "private-subnet-rtb" {
    vpc_id = aws_vpc.elite-vpc.id
    tags = {
    Name = "elite-vpc-private-subnet-rtb"
}
}

resource "aws_route_table_association" "private-rtb-a" {
    subnet_id      = aws_subnet.private-subnet-a.id
    route_table_id = aws_route_table.private-subnet-rtb.id
}

resource "aws_route_table_association" "private-rtb-b" {
    subnet_id      = aws_subnet.private-subnet-b.id
    route_table_id = aws_route_table.private-subnet-rtb.id
}

resource "aws_route_table_association" "private-rtb-c" {
    subnet_id      = aws_subnet.private-subnet-c.id
    route_table_id = aws_route_table.private-subnet-rtb.id
}

resource "aws_security_group" "elite-sg" {
    name = "secure-elite-vpc"
    description = "security group for the VPC"
    vpc_id      = aws_vpc.elite-vpc.id

     tags = {
    Name = "elite-vpc-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "elite-sg-egress" {
    security_group_id = aws_security_group.elite-sg.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1"
}