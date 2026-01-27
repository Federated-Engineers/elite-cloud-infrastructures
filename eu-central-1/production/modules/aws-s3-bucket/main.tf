provider "random" {}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "federated-engineers-bucket" {
  bucket = lower("${var.team != "" ? var.team : "federated-engineers"}-${random_id.bucket_suffix.hex}")

  tags = merge(local.common_tags, { 
    Name = "federated-engineers-bucket" 
  })
}

# Enable versioning first 
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.federated-engineers-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle configuration 
resource "aws_s3_bucket_lifecycle_configuration" "s3-lifecycle-configuration" {
  bucket = aws_s3_bucket.federated-engineers-bucket.id

  depends_on = [aws_s3_bucket_versioning.versioning]

  rule {
    id     = "transition-to-intelligent-tiering"
    status = "Enabled"

    # Transition objects to Intelligent-Tiering after 0 days
    transition {
      storage_class          = "INTELLIGENT_TIERING"
      days                   = 0
    }

    # Delete old versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = 150
    }
  }


  rule {
    id = "transition-noncurrent-versions"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

# Intelligent tiering
resource "aws_s3_bucket_intelligent_tiering_configuration" "example" {
  bucket = aws_s3_bucket.federated-engineers-bucket.id
  name   = "AutoTiering"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "SSE" {
  bucket = aws_s3_bucket.federated-engineers-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
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