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

module "balearic_blue_superyacht_services_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "balearic-blue-superyacht-services"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}


