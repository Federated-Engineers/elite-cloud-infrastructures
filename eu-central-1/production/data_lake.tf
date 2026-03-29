module "injest_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "data-lake"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "nordic_peak_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "nordic-peak"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "balearic_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "balearic"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "baltilogix-compacted-bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "baltilogix"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "scheldt-raw-data" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "scheldt-raw-datalake"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "scheldt-curated-data" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "scheldt-curated-datalake"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}
