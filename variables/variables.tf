variable "ami_id" {
  description = "ami id for ec2 instance "
  type        = string
  default     = "ami-09c813fb71547fc4f"
}
variable "ec2_instance_type" {
  description = "instance type for ec2 instance "
  type        = string
  default     = "t2.micro"
}
variable "ec2_tags" {
  description = "tags for ec2 instance "
  type        = map(any)
  default = {
    Name        = "terraform"
    terraform   = "true"
    environment = "dev"
  }
}

variable "ec2_sg" {
  description = "security group for ec2 instance "
  type        = string
  default     = "allow_all"
}

variable "sg_cidar_blocks" {
  description = "CIDR blocks for security group ingress and egress rules"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "sg_egress_from_port" {
  description = "Egress rule from port"
  type        = number
  default     = 0
}
variable "sg_egress_to_port" {
  description = "Egress rule to port"
  type        = number
  default     = 0
}
variable "sg_ingress_from_port" {
  description = "Ingress rule from port"
  type        = number
  default     = 0
}
variable "sg_ingress_to_port" {
  description = "Ingress rule to port"
  type        = number
  default     = 0
}
variable "sg_protocol" {
  description = "Protocol for security group rules"
  type        = string
  default     = "-1"
}
