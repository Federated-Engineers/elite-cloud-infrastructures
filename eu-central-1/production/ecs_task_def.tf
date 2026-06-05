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

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "elite-dbt-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}
