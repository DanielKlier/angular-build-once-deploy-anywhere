module "cicd" {
  source = "./module/cicd"

  repository              = local.github_repo
  cloudfront_prod_dist_id = module.cloudfront_prod.distribution_id
  cloudfront_test_dist_id = module.cloudfront_test.distribution_id
  deploy_bucket           = aws_s3_bucket.frontend_deployment.id
}
