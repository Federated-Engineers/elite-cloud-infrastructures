terraform {
  backend "s3" {
    bucket = "federated-engineers-terraform-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
