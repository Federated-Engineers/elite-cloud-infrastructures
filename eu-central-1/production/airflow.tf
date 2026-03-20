resource "aws_iam_policy" "airflow_s3_policy" {
  name        = "elite-airflow-s3-access-policy"
  description = "Allow Airflow to access S3 buckets"

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
          "${module.balearic_bucket.arn}/*",
          "arn:aws:s3:::gdm-raw-data",
          "arn:aws:s3:::gdm-raw-data/*"
        ]
      },

      {
        Sid    = "ReadSSMParameters"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          "arn:aws:ssm:eu-central-1:049417293525:parameter/production/google-service-account/credentials",
        ]
      }
    ]
  })
}