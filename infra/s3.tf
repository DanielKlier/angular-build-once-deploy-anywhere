resource "aws_s3_bucket" "frontend_deployment" {
  bucket = "klier-blog-frontend-deployment"
}

resource "aws_s3_bucket_public_access_block" "frontend_deployment" {
  bucket                  = aws_s3_bucket.frontend_deployment.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "frontend_deployment_bucket_access" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.frontend_deployment.arn}/staging/*"]
    principals {
      identifiers = [module.cloudfront_staging.origin_access_identity_iam_arn]
      type        = "AWS"
    }
  }

  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.frontend_deployment.arn}/prod/*"]
    principals {
      identifiers = [module.cloudfront_prod.origin_access_identity_iam_arn]
      type        = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "frontend_deployment_bucket_access" {
  bucket = aws_s3_bucket.frontend_deployment.id
  policy = data.aws_iam_policy_document.frontend_deployment_bucket_access.json
}
