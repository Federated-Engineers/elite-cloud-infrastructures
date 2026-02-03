resource "aws_security_group" "sftp-SG" {
  name   = "sftp-SG"
  vpc_id = data.aws_vpc.federated-engineers-vpc.id

  tags = {
    Description = "SG for sftp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_access" {
  security_group_id = aws_security_group.sftp-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4_traffic" {
  security_group_id = aws_security_group.sftp-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_transfer_server" "Federated-engineers-sftp" {
  endpoint_type = "PUBLIC"

  endpoint_details {
    subnet_ids         = [data.aws_subnet.public-subnet.id]
    vpc_id             = data.aws_vpc.federated-engineers-vpc.id
    security_group_ids = [aws_security_group.sftp-SG.id]
  }

  protocols = ["SFTP"]

  tags = {
    Name : "Federated-engineers-sftp"
  }
}

resource "aws_transfer_user" "rofiat" {
  server_id = aws_transfer_server.Federated-engineers-sftp.id
  user_name = "rofiat"
  role      = data.aws_iam_role.sftp-role.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${data.aws_s3_bucket.sftp-bucket.id}/$${Transfer:UserName}"
  }
}
