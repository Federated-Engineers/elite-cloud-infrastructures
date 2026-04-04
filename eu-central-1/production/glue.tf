resource "aws_glue_catalog_database" "hg_raw" {
  name        = "hg_raw"
  description = "Raw ingestion database for HG data lake"

  tags = {
    Environment = var.environment
    Team        = var.team
    Project     = var.project
  }
}