module "bbss_data_lake" {
  source          = "../modules/s3-bucket"
  team            = "elite"
  bucket-use-case = "data-layers"
  service         = "airflow"
  versioning      = "Enabled"
  environment     = var.environment
}

locals {
  data_lake_layers = [
    "raw/",
    "transformed/",
    "analytics/"
  ]
}

resource "aws_s3_object" "data_lake_layers" {
  for_each = toset(local.data_lake_layers)

  bucket = module.bbss_data_lake.bucket_name
  key    = each.value
}
