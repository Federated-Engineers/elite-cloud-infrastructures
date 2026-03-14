resource "aws_s3_bucket" "alpen_storage" {
  bucket = "alpen-mechanik"

  tags = {
    Name        = "alpen_mechanik"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "block_access" {
  bucket = aws_s3_bucket.alpen_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "sftp_user_role" {
  name = "sftp_user"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "transfer.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "sftp-user"
  }
}

resource "aws_iam_role_policy" "sftp_user_policy" {
  name = "sftp_user_policy"
  role = aws_iam_role.sftp_user_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucketObjects"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.alpen_storage.id}"
      },
      {
        Sid    = "ManageObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.alpen_storage.id}/vendor/*"
      }
    ]
  })
}

resource "aws_transfer_server" "alpen_server" {
  protocols              = ["SFTP"]
  endpoint_type          = "PUBLIC"
  identity_provider_type = "SERVICE_MANAGED"
  domain                 = "S3"

  tags = {
    Name = "Alpen_SFTP_Server"
  }
}

resource "aws_transfer_user" "vendor" {
  server_id           = aws_transfer_server.alpen_server.id
  user_name           = "vendor"
  role                = aws_iam_role.sftp_user_role.arn
  home_directory_type = "LOGICAL"

  home_directory_mappings {
    entry  = "/"
    target = "/${aws_s3_bucket.alpen_storage.id}/vendor"
  }
}

resource "tls_private_key" "sftp_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_transfer_ssh_key" "server_key" {
  server_id = aws_transfer_server.alpen_server.id
  user_name = aws_transfer_user.vendor.user_name
  body      = trimspace(tls_private_key.sftp_ssh_key.public_key_openssh)
}

# displaying my private key
output "sftp_private_key" {
  value     = tls_private_key.sftp_ssh_key.private_key_pem
  sensitive = true
}
