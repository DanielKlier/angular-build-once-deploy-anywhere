data "aws_caller_identity" "caller_identity" {}

data "aws_s3_bucket" "deploy_bucket" {
  bucket = var.deploy_bucket
}

data "aws_cloudfront_distribution" "prod" {
  id = var.cloudfront_prod_dist_id
}

data "aws_cloudfront_distribution" "test" {
  id = var.cloudfront_test_dist_id
}
