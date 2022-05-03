resource "random_string" "tenant" {
  length  = 5
  upper   = false
  special = false
  lower   = true
  number  = true
}

resource "aws_s3_bucket" "tenant" {
  bucket = "s3-${var.tenant_name}-${random_string.tenant.result}"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      aws_s3_bucket.tenant.arn,
      "${aws_s3_bucket.tenant.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.tenant_oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "tenant" {
  bucket = aws_s3_bucket.tenant.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
