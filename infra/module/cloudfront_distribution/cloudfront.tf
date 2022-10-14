resource "aws_cloudfront_distribution" "frontend" {
  enabled = true
  default_root_object = var.default_root_object
  price_class = "PriceClass_100"
  comment = "${var.origin_path} - Klier Blog"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
  }

  origin {
    domain_name = data.aws_s3_bucket.origin_bucket.bucket_regional_domain_name
    origin_id   = local.origin_id
    origin_path = "/${var.origin_path}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  // required for Angular path routing
  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 30
    response_code         = 200
    response_page_path    = var.default_root_object
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 30
    response_code         = 200
    response_page_path    = var.default_root_object
  }
}

resource "aws_cloudfront_origin_access_identity" "frontend" {
  comment = "access-identity-${data.aws_s3_bucket.origin_bucket.bucket_regional_domain_name}"
}
