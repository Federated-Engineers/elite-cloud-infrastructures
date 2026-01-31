terraform {
  backend "s3" {
    bucket = "federated-engineers-production-state"
    key    = "production/terraform.tfstate"
    region = "eu-central-1"
  }
}
