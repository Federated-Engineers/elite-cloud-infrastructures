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
          "s3:*Object*",
        ]

        # add your bucket here
        Resource = [
          "${module.injest_bucket.arn}" 
          ,"${module.injest_bucket.arn}/*"

        ]
      },
    ]
  })
}

