output "origin_access_identity_iam_arn" {
  value = aws_cloudfront_origin_access_identity.frontend.iam_arn
}

output "distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}
