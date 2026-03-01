terraform {
  backend "s3" {
    bucket = "federated-engineers-terraform-state"
    key    = "production/elite/terraform.tfstate"
    region = "eu-central-1"
  }
}
