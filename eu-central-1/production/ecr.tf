resource "aws_ecr_repository" "elite_airflow" {
  name                 = "elite-airflow"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-airflow" })
}


data "aws_ecr_lifecycle_policy_document" "elite_airflow" {
  rule {
    priority    = 1
    description = "To delete ecr images so that only the last 3 recent images are kept"
    action {
      type = "expire"
    }

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_airflow" {
  repository = aws_ecr_repository.elite_airflow.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_airflow.json
}

resource "aws_ecr_repository" "elite_dbt" {
  name                 = "elite-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    Name = "elite-dbt"
  })
}

data "aws_ecr_lifecycle_policy_document" "elite_dbt" {

  rule {
    priority    = 1
    description = "Keep only latest 3 dbt images"

    action {
      type = "expire"
    }

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_dbt" {

  repository = aws_ecr_repository.elite_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_dbt.json
}
