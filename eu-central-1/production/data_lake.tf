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


resource "aws_glue_catalog_database" "elite_prod" {
  name = "scheldt-production-database"

  tags = merge(local.common_tags, {
    Owner   = "Scheldt-River-Logistics",
    Service = "elite-airflow"
  })
}

resource "aws_glue_catalog_database" "scardinavas_db" {
  name = "scardinavas-database"

  tags = merge(local.common_tags, {
    Owner   = "scardinavas-monaco",
    Service = "elite-airflow"
  })
}
