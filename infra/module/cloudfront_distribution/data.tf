data "aws_s3_bucket" "origin_bucket" {
  bucket = var.origin_bucket_name
}
