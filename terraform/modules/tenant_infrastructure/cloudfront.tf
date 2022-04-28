resource "aws_cloudfront_origin_access_identity" "tenant_oai" {
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled = true
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.cloudfront_whitelist
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  origin {
    origin_id   = var.tenant_name
    domain_name = aws_s3_bucket.tenant.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.tenant_oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET", "OPTIONS"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = var.tenant_name
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }
  }
}
