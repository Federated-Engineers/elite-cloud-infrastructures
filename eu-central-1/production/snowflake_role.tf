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
          AWS = "049417293525"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "0000"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "elite_snowflake_s3_policy" {
  name        = "elite-snowflake-policy"
  description = "Allow Snowflake to read from lonestar-assurance-lake"

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
          "arn:aws:s3:::angel-city-health-data",
          "arn:aws:s3:::angel-city-health-data/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elite_snowflake_s3_attachment" {
  role       = aws_iam_role.elite_snowflake_s3_role.name
  policy_arn = aws_iam_policy.elite_snowflake_s3_policy.arn
}
