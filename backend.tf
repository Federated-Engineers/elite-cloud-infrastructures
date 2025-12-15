terraform {
  backend "s3" {
    bucket = "terraform-backend-test"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
