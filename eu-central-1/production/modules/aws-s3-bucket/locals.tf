locals {
  common_tags = {
    team      = var.team
    project   = var.project
    terraform = true
  }

  # requested pattern: environment-organisation-team-relatedproject
  bucket_name = lower(replace("${var.environment}-${var.project}-${var.team}-${var.related_project}", " ", "-"))
}
