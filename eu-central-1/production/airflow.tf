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
          "${module.lumina_bricks_properties_bucket.arn}/*",
          module.mare_viva_bucket.arn,
          "${module.mare_viva_bucket.arn}/*",
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
          "arn:aws:ssm:eu-central-1:049417293525:parameter/staging/elite/snowflake/*",
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

resource "aws_iam_policy" "airflow_ecs_access_policy" {

  name        = "airflow_ecs_access_policy"
  description = "Allow  all Elite Data Engineer Airflow users to run ECS dbt tasks"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "RunECSTasks"
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "ecs:DescribeTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeClusters",
          "ecs:ListTasks"
        ]

        Resource = "*"
      },

      {
        Sid    = "PassTaskRoles"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]

        Resource = [
          aws_iam_role.ecs_task_execution_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "ecs_group_access" {
  group      = "elite-data-engineers"
  policy_arn = aws_iam_policy.airflow_ecs_access_policy.arn
}
