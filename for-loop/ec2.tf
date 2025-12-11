resource "aws_instance" "terraform" {
  for_each        = toset(var.instance_name)
  ami             = var.ami_id
  instance_type   = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name      = each.value
    terraform = "true"
  }


}
resource "aws_security_group" "allow_all" {
  # ... other configuration ...
  name = "allow_all"
  egress {
    from_port   = 0 # from and to port 0 means all ports
    to_port     = 0
    protocol    = "-1" # means all protocols 
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "terraform_sg"
  }
}
