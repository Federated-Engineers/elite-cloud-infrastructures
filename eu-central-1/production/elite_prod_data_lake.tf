module "injest_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "data-lake"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = "var.environment"
}