terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

}
provider "aws" {
  alias  = "primary"
  region = var.aws_primary_region
}
provider "aws" {
  alias  = "secondary"
  region = var.aws_secondary_region
}