resource "aws_s3_bucket" "federated-engineers-bucket" {
  bucket = "federated-engineers-${var.environment}-${var.team}-${var.bucket-use-case}"

  tags = merge(local.common_tags, {
    Name = "federated-engineers-${var.environment}-${var.team}-${var.bucket-use-case}"
  })
}

#  versioning 
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.federated-engineers-bucket.id

  versioning_configuration {
    status = var.versioning
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.federated-engineers-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}