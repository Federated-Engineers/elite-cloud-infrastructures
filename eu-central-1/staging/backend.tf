terraform {
  backend "s3" {
    bucket = "federated-engineers-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "eu-central-1"
  }
}
