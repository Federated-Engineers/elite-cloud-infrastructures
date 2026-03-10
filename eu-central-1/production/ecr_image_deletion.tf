data "aws_ecr_lifecycle_policy_document" "elite_airflow" {
  rule {
    priority    = 1
    description = "To delete images to leave only the last 3 recent images are kept"
    action {
      type = "expire"
    }

    selection {
      tag_status      = "any"
      count_type      = "imageCountMoreThan"
      count_number    = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_airflow" {
  repository = aws_ecr_repository.elite_airflow.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_airflow.json
}
