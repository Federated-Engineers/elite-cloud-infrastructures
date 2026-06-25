resource "aws_iam_policy" "snowflake_s3_integration_policy" {
  name        = "elite-snowflake-s3-integration-policy"
  description = "Allow Snowflake access to S3 buckets for data integration"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        "Resource" : "arn:aws:s3:::kings-county-raw-ingestion/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : "arn:aws:s3:::kings-county-raw-ingestion",
        "Condition" : {
          "StringLike" : {
            "s3:prefix" : [
              "*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "snowflake_s3_integration_role" {
  name        = "elite-snowflake-s3-integration-role"
  description = "IAM role assumed by Snowflake to access the S3 buckets"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = ["1234567890"]
        }

        Action = "sts:AssumeRole"

        Condition = {
          StringEquals = {
            "sts:ExternalId" = ["0000"]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "snowflake_s3_integration_attachment" {
  role       = aws_iam_role.snowflake_s3_integration_role.name
  policy_arn = aws_iam_policy.snowflake_s3_integration_policy.arn
}
