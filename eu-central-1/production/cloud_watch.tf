resource "aws_cloudwatch_log_group" "angel_city_dbt_logs" {
  name = "angel-city-health-dbt-logs"

  tags = merge(
    local.common_tags,
    {
      Name = "angel_city_logs"

    }
  )
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "elite_kings_county_dbt_logs" {
  name = "elite-kings-county-dbt-logs"

  tags = merge(local.common_tags,
    { Name = "elite-kings-county-dbt-logs" }
  )

  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "elite_lonestar_dbt_logs" {
  name              = "elite_lonestar-dbt-logs"
  retention_in_days = 14
  log_group_class   = "STANDARD"

  tags = merge(local.common_tags,
    { Name = "elite-lonestar-dbt-logs" }
  )
}

resource "aws_cloudwatch_log_group" "elite_lone_star_assurance_dbt_logs" {
  name              = "elite-lone-star-assurance-dbt-logs"
  log_group_class   = "STANDARD"
  retention_in_days = 14

  tags = merge(local.common_tags,
    { Name = "elite-lone-star-assurance-dbt-logs" }
  )
}
