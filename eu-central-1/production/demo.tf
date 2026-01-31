resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucketwhatever123"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}