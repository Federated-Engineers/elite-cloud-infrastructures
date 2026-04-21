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

module "scheldt-river-bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "scheldt"
  service         = "elite-airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "scardinavas_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "scardinavas"
  service         = "elite-airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "horlogerie_de_geneve_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "horlogerie-de-geneve"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "lumina_bricks_properties_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "lumina-bricks-properties"
  service         = "elite-airflow"
  versioning      = "Enabled"
  environment     = var.environment
}
module "liffey_luxury_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "liffey-luxury"
  service         = "elite-airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "athena_query_results_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "athena-query-results"
  service         = "elite-airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

module "mare_viva_bucket" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "mare-viva-bucket"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

