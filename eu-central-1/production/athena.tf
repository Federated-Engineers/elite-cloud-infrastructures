resource "aws_athena_workgroup" "elite_team" {
  name = "elite_team"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    engine_version {
      selected_engine_version = "Athena engine version 3"
    }

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