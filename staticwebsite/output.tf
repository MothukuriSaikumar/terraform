output "s3_bucket_id" {
  value = aws_s3_bucket.s3.bucket

}

output "url_s3_bucket" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}