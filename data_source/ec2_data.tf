data "aws_ami" "instance_ami_id" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]

  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }

  owners = ["099720109477"]

  region = "us-east-1"

}




output "instance_ami_id" {
  value = data.aws_ami.instance_ami_id.id
}