resource "aws_cloudwatch_log_group" "angel_city_dbt_logs" {
  name = "angel-city-health-dbt-logs"

  tags = merge(
    local.common_tags,
    {
      Name = "angel_city_logs"

    }
  )
}

resource "aws_cloudwatch_log_group" "elite_kings_county_dbt" {
  name = "elite-kings-county-dbt"

  tags = merge(local.common_tags,
    { Name = "elite-kings-county-dbt-logs"}
  )
}