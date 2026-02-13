resource "aws_s3_bucket" "example" {
  bucket = "staging-federated-engineers-adhoc"

  tags = local.common_tags
}

resource "aws_s3_bucket" "example" {
  bucket = "staging-federated-engineers-adhoc-1"

  tags = local.common_tags
}