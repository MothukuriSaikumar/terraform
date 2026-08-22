variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
  default     = "s3staticwebterraform"
}


variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name."
  type        = string
  default     = "my-static-website-"
}
