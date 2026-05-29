resource "aws_ecs_cluster" "angel_city_cluster" {
  name = "angel-city-health_cluster"

  tags = merge(
    local.common_tags,
    {
      Name = "elite-dbt"

    }
  )
}
