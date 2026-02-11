module "elite_engineers_staging_zone" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  service         = "airflow"
  bucket-use-case  = "data-lake" 
  versioning      = false
  environment     = var.environment
}
