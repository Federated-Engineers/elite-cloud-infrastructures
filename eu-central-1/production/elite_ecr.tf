resource "aws_ecr_repository" "elite_airflow" {
  name                 = "elite-airflow"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-airflow" })
}
