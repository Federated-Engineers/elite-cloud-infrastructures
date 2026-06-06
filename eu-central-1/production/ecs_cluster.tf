resource "aws_ecs_cluster" "angel_city_cluster" {
  name = "angel-city-health-cluster"

  tags = merge(
    local.common_tags,
    {
      Name = "angel_city_cluster"

    }
  )
}

resource "aws_ecs_cluster" "elite_lone_star" {
  name = "elite-lone-star-cluster"

  tags = merge(
    local.common_tags,
    {
      Name = "lone_star_cluster"

    }
  )
}

resource "aws_ecs_cluster" "elite_kings_county_dbt" {
  name = "elite-kings-county-dbt"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  tags = merge(local.common_tags,
    { Name = "elite-kings-county-dbt" }
  )
}
