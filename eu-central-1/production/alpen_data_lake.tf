module "sftp_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "alpen-sftp-server"
  service         = "airflow"
  versioning      = "Disabled"
  environment     = var.environment
}
