resource "aws_iam_policy" "airflow_s3_policy" {
  name        = "airflow-staging-s3-access"
  description = "Allow Airflow to access staging bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
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

resource "aws_iam_role_policy_attachment" "airflow_attach_policy" {
  role       = aws_iam_role.airflow_role.name
  policy_arn = aws_iam_policy.airflow_s3_policy.arn
}