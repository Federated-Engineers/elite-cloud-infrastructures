
resource "aws_iam_policy" "staging_bucket_rw" {
  name = "staging-bucket-read-write"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = [
          module.elite_engineers_staging_zone.arn
        ]
      },
      {
        Sid    = "ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${module.elite_engineers_staging_zone.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "airflow-dev-user" {
  name = "elite-airflow-dev-user"
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.airflow-dev-user.name
  policy_arn = aws_iam_policy.staging_bucket_rw.arn
}

resource "aws_iam_group_policy_attachment" "attach_group_access" {
  group      = "elite-data-engineers"
  policy_arn = aws_iam_policy.staging_bucket_rw.arn
}

resource "aws_iam_access_key" "airflow_dev_secret_key" {
  user = aws_iam_user.airflow-dev-user.name
}

resource "aws_ssm_parameter" "staging_access_key" {
  name  = "/staging/elite/airflow-dev/aws-access-key"
  type  = "SecureString"
  value = aws_iam_access_key.airflow_dev_secret_key.id
}

resource "aws_ssm_parameter" "staging_secret_key" {
  name  = "/staging/elite/airflow-dev/aws-secret-key"
  type  = "SecureString"
  value = aws_iam_access_key.airflow_dev_secret_key.secret
}

