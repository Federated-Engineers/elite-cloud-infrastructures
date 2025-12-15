resource "aws_s3_bucket" "ecommerce_raw" {
  bucket = "raw-data-ecommerce-bucket"
}
resource "aws_s3_bucket" "ecommerce_raw_datalake" {
  bucket = "ecommerce-bucket-raw-data"
}