resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucketwhatever"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}