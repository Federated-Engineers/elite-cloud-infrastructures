resource "aws_s3_bucket" "adhoc_bucket" {
  bucket = "staging-federated-engineers-adhoc"

  tags = local.common_tags
}

module "elite_engineers_staging_zone" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  service         = "airflow"
  bucket-use-case = "data-lake"
  versioning      = "Suspended"
  environment     = var.environment
}