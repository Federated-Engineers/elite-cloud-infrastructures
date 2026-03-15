module "sftp_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "sftp"
  service         = "airflow"
  versioning      = "Disabled"
  environment     = var.environment
}
