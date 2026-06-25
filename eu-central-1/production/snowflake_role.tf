resource "aws_iam_role" "elite_snowflake_s3_role" {
  name        = "elite-snowflake-role"
  description = "Allow Snowflake storage integration to assume role for S3 access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSnowflakeAssume"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = ["arn:aws:iam::650012445037:user/0trs1000-s",
          "arn:aws:iam::269657857787:user/wv0u1000-s"]
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = ["SQ35311_SFCRole=5_+0fH4prUkj3DW/Sd1ptZfnCLB/E=",
            "KY10182_SFCRole=121_VYSuNn1eQ6Bsm66MFrEm6/Ov3A0="]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "elite_snowflake_s3_policy" {
  name        = "elite-snowflake-policy"
  description = "Allow Snowflake to read from S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Read"
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::lone-star-assurance-lake",
          "arn:aws:s3:::lone-star-assurance-lake/*",
          "arn:aws:s3:::kings-county-raw-ingestion",
          "arn:aws:s3:::kings-county-raw-ingestion/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elite_snowflake_s3_attachment" {
  role       = aws_iam_role.elite_snowflake_s3_role.name
  policy_arn = aws_iam_policy.elite_snowflake_s3_policy.arn
}
