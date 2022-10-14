module "cloudfront_prod" {
  source = "./module/cloudfront_distribution"

  origin_bucket_name = aws_s3_bucket.frontend_deployment.bucket
  origin_path = "prod"
}

module "cloudfront_test" {
  source = "./module/cloudfront_distribution"

  origin_bucket_name = aws_s3_bucket.frontend_deployment.bucket
  origin_path = "test"
}
