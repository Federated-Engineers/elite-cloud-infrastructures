terraform {
  backend "s3" {
    bucket = "federated-engineers-terraform-state"
    key    = "staging/elite/terraform.tfstate"
    region = "eu-central-1"
  }
}
