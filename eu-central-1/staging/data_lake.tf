module "elite_engineers_staging_zone" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  service         = "airflow"
  bucket-use-case = "data-lake"
  versioning      = "Suspended"
  environment     = var.environment
}

module "elite_engineers_staging_athena_query_results" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  service         = "airflow"
  bucket-use-case = "athena-query-results"
  versioning      = "Suspended"
  environment     = var.environment
}
