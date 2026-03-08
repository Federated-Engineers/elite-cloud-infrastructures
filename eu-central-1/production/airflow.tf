resource "aws_iam_policy" "airflow_policy" {
  name        = "elite-airflow-access-policy"
  description = "Allow Airflow to access aws resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Readandwrite"
        Effect = "Allow"
        Action = [
          "s3:List*",
          "s3:*Object*"
        ]
        Resource = [
          module.injest_bucket.arn,
          "${module.injest_bucket.arn}/*",
          module.nordic_peak_bucket.arn,
          "${module.nordic_peak_bucket.arn}/*",
          module.balearic_bucket.arn,
          "${module.balearic_bucket.arn}/*"
        ]
      }
    ]
  })
}