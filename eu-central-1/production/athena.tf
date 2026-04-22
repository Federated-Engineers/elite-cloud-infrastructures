resource "aws_athena_workgroup" "elite_data_engineering_team" {
  name = "elite-data_engineering_team"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${module.athena_query_results_bucket.bucket_name}/${var.environment}/queries/"

    }
  }

  tags = {
    Team        = "elite"
    Environment = var.environment
    Service     = "elite-airflow"
  }
}