terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }
  backend "s3" {
    bucket = "practice86sterraformstate"
    key    = "remote-statefile"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
  
}