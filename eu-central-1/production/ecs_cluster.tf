resource "aws_ecs_cluster" "angel_city_cluster" {
  name = "angel-city-health-cluster"

  tags = merge(
    local.common_tags,
    {
      Name = "angel_city_cluster"

    }
  )
}
