data "aws_ssm_parameter" "elite_dbt_snowflake_password" {
  name = "/staging/elite/snowflake/snowflake_password"
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_ssm_parameter" "elite_kings_county_snowflake_password" {
  name = "/production/elite/snowflake/kings_county/snowflake_password"
}

data "aws_ssm_parameter" "lonestar_snowflake_password" {
  name = "/production/forge/snowflake/lone-star-assurance/snowflake_password"
}

data "aws_ssm_parameter" "lone_star_assurance_snowflake_password" {
  name = "/production/elite/snowflake/lone-star-assurance/snowflake_password"
}