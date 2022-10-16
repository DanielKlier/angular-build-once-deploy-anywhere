module "cloudfront_prod" {
  source = "./module/cloudfront_distribution"

  origin_bucket_name = aws_s3_bucket.frontend_deployment.id
  origin_path = "prod"
}

module "cloudfront_staging" {
  source = "./module/cloudfront_distribution"

  origin_bucket_name = aws_s3_bucket.frontend_deployment.id
  origin_path = "staging"
}
