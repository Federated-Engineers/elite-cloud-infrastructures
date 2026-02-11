module "elite_engineers_staging_zone" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  service         = "airflow"
  bucket_use_case  = "staging-zone" 
  versioning      = "Enabled"
  environment     = var.environment
}
