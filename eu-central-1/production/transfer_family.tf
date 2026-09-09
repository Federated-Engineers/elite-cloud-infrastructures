
# NETWORKING

data "aws_vpc" "federated_vpc" {
  id = var.production-vpc
}

resource "aws_security_group" "allow_ssh_to_sftp" {
  name        = "sftp_sg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = var.production-vpc

  tags = merge(local.common_tags,
    { Name = "sftp_sg" }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh_to_sftp.id
  cidr_ipv4         = data.aws_vpc.federated_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_to_sftp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_eip" "sftp_server" {
  domain = "vpc"
  tags   = local.common_tags
}


# IAM

data "aws_iam_policy_document" "read_s3" {
  statement {
    sid = "readS3"

    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Describe*"
    ]

    resources = [
      "${module.client_alpenmachanik_sftp_server_storage.arn}/repairpartner",
      "${module.client_alpenmachanik_sftp_server_storage.arn}/repairpartner/*"
    ]
  }

}


resource "aws_iam_role_policy" "sftp_policy" {
  name = "sftp_policy"
  role = aws_iam_role.transfer_family.id

  policy = data.aws_iam_policy_document.read_s3.json
}


data "aws_iam_policy_document" "sftp_assumerole" {
  statement {
    sid = "sftp_assumerole"

    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }

}


resource "aws_iam_role" "transfer_family" {
  name = "alpenmechanik_sftp"

  assume_role_policy = data.aws_iam_policy_document.sftp_assumerole.json
}



# TRANSFER FAMILY SERVER

resource "aws_transfer_server" "alpenmechanik_sftp" {
  endpoint_type = "VPC"

  endpoint_details {
    address_allocation_ids = [aws_eip.sftp_server.id]
    vpc_id                 = data.aws_vpc.federated_vpc.id
    subnet_ids             = [var.production-vpc-subnet-public-a, var.production-vpc-subnet-public-b]
    security_group_ids     = [aws_security_group.allow_ssh_to_sftp.id]

  }

  protocols = ["SFTP"]

  tags = local.common_tags
}


# TRANSFER FAMILY USER
resource "aws_transfer_user" "repairpartner" {
  server_id  = aws_transfer_server.alpenmechanik_sftp.id
  user_name  = "repairpartner"
  role       = aws_iam_role.transfer_family.arn
  depends_on = [aws_iam_role_policy.sftp_policy]

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/"
    target = "/${module.client_alpenmachanik_sftp_server_storage.bucket_name}/repairpartner"
  }

}

resource "aws_transfer_ssh_key" "example" {
  server_id = aws_transfer_server.alpenmechanik_sftp.id
  user_name = aws_transfer_user.repairpartner.user_name
  body      = trimspace("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHzXuOxuUkJ6c5ux/Ty0gEcmlWY0ZMOqqV/Bfvg6pcs taofeecoh@taofeecoh")
}
