module "sftp_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "alpen-sftp"
  service         = "airflow"
  versioning      = "Disabled"
  environment     = var.environment
}

resource "aws_iam_role" "sftp_user_role" {
  name     = "sftp_user"
  tags_all = merge(local.common_tags, { Name = "SFTPWriteToS3" })

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

  tags = merge(local.common_tags, { Name = "${module.sftp_bucket.bucket_name}" })
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
        Resource = "${module.sftp_bucket.arn}"
      },
      {
        Sid    = "ManageObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${module.sftp_bucket.arn}/vendor/*"
      }
    ]
  })
}

resource "aws_transfer_server" "alpen_server" {
  protocols              = ["SFTP"]
  endpoint_type          = "PUBLIC"
  identity_provider_type = "SERVICE_MANAGED"
  domain                 = "S3"

  tags = merge(local.common_tags, { Name = "${module.sftp_bucket.bucket_name}" })
}

resource "aws_transfer_user" "vendor" {
  server_id           = aws_transfer_server.alpen_server.id
  user_name           = "vendor"
  role                = aws_iam_role.sftp_user_role.arn
  home_directory_type = "LOGICAL"

  tags = local.common_tags

  home_directory_mappings {
    entry  = "/"
    target = "/${module.sftp_bucket.arn}/vendor"
  }
}

data "aws_ssm_parameter" "alpen_public_key" {
  name = "/production/elite/alpen_mechaniks/sftp_server/alpen_ssh_keys.pub"
}

resource "aws_transfer_ssh_key" "server_key" {
  server_id = aws_transfer_server.alpen_server.id
  user_name = aws_transfer_user.vendor.user_name
  body      = data.aws_ssm_parameter.alpen_public_key.value
}



