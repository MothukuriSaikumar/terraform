resource "aws_instance" "terraform" {
  ami                    = "ami-09c813fb71547fc4f"
  instance_type          = "t2.micro"
  count                  = 4
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name      = var.multiple_instances[count.index]
    terraform = "true"
  }
}

resource "aws_security_group" "allow_all" {
  # ... other configuration ...
  name = "allow_all"

  egress {
    from_port        = 0 # from and to port 0 means all ports
    to_port          = 0
    protocol         = "-1" # means all protocols 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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