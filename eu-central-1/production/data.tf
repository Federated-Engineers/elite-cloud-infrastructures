data "aws_ssm_parameter" "elite_dbt_snowflake_account" {
  name = "/staging/elite/snowflake/snowflake_account"
}

data "aws_ssm_parameter" "elite_dbt_snowflake_database" {
  name = "/staging/elite/snowflake/snowflake_database"
}

data "aws_ssm_parameter" "elite_dbt_snowflake_password" {
  name = "/staging/elite/snowflake/snowflake_password"
}

data "aws_ssm_parameter" "elite_dbt_snowflake_role" {
  name = "/staging/elite/snowflake/snowflake_role"
}

data "aws_ssm_parameter" "elite_dbt_snowflake_schema" {
  name = "/staging/elite/snowflake/snowflake_schema"
}

data "aws_ssm_parameter" "elite_dbt_snowflake_user" {
  name = "/staging/elite/snowflake/snowflake_user"
}

data "aws_ssm_parameter" "elite_dbt_snowflake_warehouse" {
  name = "/staging/elite/snowflake/snowflake_warehouse"
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