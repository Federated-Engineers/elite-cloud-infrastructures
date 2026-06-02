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
      Name = "angel_city_cluster"

    }
  )
}
