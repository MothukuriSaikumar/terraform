variable "aws_primary_region" {
  description = "The AWS region for the primary VPC"
  type        = string
  default     = "us-east-1"

}
variable "aws_secondary_region" {
  description = "The AWS region for the secondary VPC"
  type        = string
  default     = "us-west-1"

}
variable "primary_vpc_cidr" {
  description = "The CIDR block for the primary VPC"
  type        = string
  default     = "10.0.0.0/16"

}
variable "secondary_vpc_cidr" {
  description = "The CIDR block for the secondary VPC"
  type        = string
  default     = "10.1.0.0/16"

}
variable "primary_subnet_cidrs" {
  description = "A list of CIDR blocks for the primary VPC subnets"
  type        = string
  default     = "10.0.1.0/24"
}
variable "secondary_subnet_cidrs" {
  description = "A list of CIDR blocks for the secondary VPC subnets"
  type        = string
  default     = "10.1.1.0/24"
}
variable "aws_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t3.micro"

}
variable "primary_access_key" {
  description = "The access key for the primary for instance" # region = us-east-1
  type        = string
  default     = ""

}
variable "secondary_access_key" {
  description = "The access key for the secondary for instance" # region = us-west-1
  type        = string
  default     = ""

}
