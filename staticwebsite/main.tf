resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "s3_website_public_access_block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_cloudfront_origin_access_control" "s3_website_oac" {
  name                              = "s3-website-oac"
  description                       = "Origin Access Control for S3 Website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_s3_bucket_policy" "s3_website_policy" {
  bucket = aws_s3_bucket.s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com" # Replace with the AWS account ID of the other account
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn 
          }
        }
      }
    ]
  })
}
# upload the index.html file to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.s3.id
  source       = "${path.module}/www/index.html"
  key          = "index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/www/index.html")
}

# upload the error.html file to the S3 bucket
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.s3.id
  source = "${path.module}/www/error.html"
  etag   = filemd5("${path.module}/www/error.html")
  key    = "error.html"

  content_type = "text/html"
}
# create a cloudfront distribution for the S3 bucket
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.s3.bucket_regional_domain_name
    origin_id                = "s3-${aws_s3_bucket.s3.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_website_oac.id


  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 Website Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${aws_s3_bucket.s3.id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


