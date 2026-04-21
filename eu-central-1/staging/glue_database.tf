resource "aws_glue_catalog_database" "staging_db" {
  name = "${var.project}-${var.team}-${var.environment}-db"

  tags = merge(local.common_tags, {
    Owner   = var.team,
    Service = "elite-airflow"
  })
}
