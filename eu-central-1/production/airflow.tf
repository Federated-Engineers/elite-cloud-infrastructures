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
          "${module.balearic_bucket.arn}/*",
          "arn:aws:s3:::gdm-raw-data",
          "arn:aws:s3:::gdm-raw-data/*",
          module.baltilogix-compacted-bucket.arn,
          "${module.baltilogix-compacted-bucket.arn}/*",
          "arn:aws:s3:::baltilogix-raw-ingestion",
          "arn:aws:s3:::baltilogix-raw-ingestion/*",
          module.scheldt-river-bucket.arn,
          "${module.scheldt-river-bucket.arn}/*",
          module.scardinavas_bucket.arn,
          "${module.scardinavas_bucket.arn}/*",
          module.horlogerie_de_geneve_bucket.arn,
          "${module.horlogerie_de_geneve_bucket.arn}/*",
          module.liffey_luxury_bucket.arn,
          "${module.liffey_luxury_bucket.arn}/*",
          module.lumina_bricks_properties_bucket.arn,
          "${module.lumina_bricks_properties_bucket.arn}/*"
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
          "arn:aws:ssm:eu-central-1:049417293525:parameter/supabase/database/credentials",
        ]
      },

      {
        Sid    = "GlueActions"
        Effect = "Allow"
        Action = [
          "glue:*"
        ]
        Resource = ["*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "allow_elite_query_results" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${module.athena_query_results_bucket.bucket_name}",
      "arn:aws:s3:::${module.athena_query_results_bucket.bucket_name}/*"
    ]
  }
}

data "aws_iam_policy_document" "deny_elite_query_results" {
  statement {
    effect = "Deny"

    actions = [
      "s3:DeleteObject",
      "s3:DeleteBucket"
    ]

    resources = [
      "arn:aws:s3:::${module.athena_query_results_bucket.bucket_name}",
      "arn:aws:s3:::${module.athena_query_results_bucket.bucket_name}/*"
    ]
  }
}

data "aws_iam_policy_document" "deny_other_workgroups" {
  statement {
    effect = "Deny"

    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:UpdateWorkGroup",
      "athena:GetWorkGroup",
      "athena:ListWorkGroups"
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "athena:WorkGroup"
      values   = ["elite_team"]
    }
  }
}