resource "aws_ecs_task_definition" "angel_city_dbt_task" {
  family                   = "elite-dbt-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  tags = merge(
    local.common_tags,
    {
      Name = "angel_city_task"

    }
  )

  container_definitions = jsonencode([
    {
      name      = "elite-dbt"
      image     = "${aws_ecr_repository.elite_dbt.repository_url}:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.angel_city_dbt_logs.name
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      secrets = [
        {
          name      = "SNOWFLAKE_ACCOUNT"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_account.arn
        },
        {
          name      = "SNOWFLAKE_DATABASE"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_database.arn
        },
        {
          name      = "SNOWFLAKE_PASSWORD"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_password.arn
        },
        {
          name      = "SNOWFLAKE_ROLE"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_role.arn
        },
        {
          name      = "SNOWFLAKE_SCHEMA"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_schema.arn
        },
        {
          name      = "SNOWFLAKE_USER"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_user.arn
        },
        {
          name      = "SNOWFLAKE_WAREHOUSE"
          valueFrom = data.aws_ssm_parameter.elite_dbt_snowflake_warehouse.arn
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "elite_kings_county_dbt_task" {
  family                   = "elite-kings-county-dbt-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "elite-kings-county-dbt"
      image     = "${aws_ecr_repository.elite_kings_county_ledger_dbt.repository_url}:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.elite_kings_county_dbt_logs.name
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        { name : "account", value : "UJYDCFM-ZZ49269" },
        { name : "database", value : "SLEEKMART_OMS" },
        { name : "user", value : "THEJOYVICTOR" },
        { name : "role", value : "ACCOUNTADMIN" },
        { name : "warehouse", value : "transforming" },
        { name : "schema", value : "L1_LANDING" }
      ]

      secrets = [
        {
          name      = "ELITE_KINGS_COUNTY_SNOWFLAKE_PASSWORD"
          valueFrom = data.aws_ssm_parameter.elite_kings_county_snowflake_password.arn
        }
      ]
    }
  ])

  tags = merge(local.common_tags,
    { Name = "elite-kings-county-dbt-task" }
  )
}

resource "aws_ecs_task_definition" "elite_lonestar_dbt_task" {
  family                   = "elite_lonestar-dbt-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "elite-lonestar-dbt"
      image     = "${aws_ecr_repository.elite_lonestar_dbt.repository_url}:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.elite_lonestar_dbt_logs.name
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        {
          name  = "SNOWFLAKE_ACCOUNT"
          value = "MGUBPDR-MY23767"
        },
        {
          name  = "SNOWFLAKE_DATABASE"
          value = "TEST_DB"
        },
        {
          name  = "SNOWFLAKE_ROLE"
          value = "ACCOUNTADMIN"
        },
        {
          name  = "SNOWFLAKE_SCHEMA"
          value = "BRONZE_TEST"
        },
        {
          name  = "SNOWFLAKE_USER"
          value = "MOOSTAPHAR"
        },
        {
          name  = "SNOWFLAKE_WAREHOUSE"
          value = "COMPUTE_WH"
        }
      ]
      secrets = [
        {
          name      = "SNOWFLAKE_PASSWORD"
          valueFrom = data.aws_ssm_parameter.lonestar_snowflake_password.arn
        }
      ]
    }
  ])

  tags = merge(local.common_tags,
    { Name = "elite_lonestar-dbt-task" }
  )
}


resource "aws_ecs_task_definition" "elite_lone_star_assurance_dbt_task" {
  family                   = "elite_lone_star_assurance_dbt_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "elite-lone-star"
      image     = "${aws_ecr_repository.elite_lone_star_dbt.repository_url}:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.elite_lone_star_assurance_dbt_logs.name
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        { name : "SNOWFLAKE_ACCOUNT", value : "YGUEVLA-ID96582" },
        { name : "SNOWFLAKE_DATABASE", value : "lone_star_database" },
        { name : "SNOWFLAKE_USER", value : "CHIZOBAEZE" },
        { name : "SNOWFLAKE_ROLE", value : "ACCOUNTADMIN" },
        { name : "SNOWFLAKE_WAREHOUSE", value : "lone_star" },
        { name : "SNOWFLAKE_SCHEMA", value : "lone_schema" }
      ]

      secrets = [
        {
          name      = "ELITE_LONE_STAR_SNOWFLAKE_PASSWORD"
          valueFrom = data.aws_ssm_parameter.lone_star_assurance_snowflake_password.arn
        }
      ]
    }
  ])

  tags = merge(local.common_tags,
    { Name = "elite_lone_star_assurance_dbt_task" }
  )
}
