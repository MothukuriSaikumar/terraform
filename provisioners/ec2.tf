resource "aws_instance" "terraform1" {
  ami                    = "ami-09c813fb71547fc4f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]



  tags = {
    Name      = "terraform"
    terraform = "true"
  }
  provisioner "local-exec" {
    command    = "echo ${self.private_ip} > private_ip.txt"
    on_failure = continue
  }
  connection {
    type     = "ssh"
    host     = self.public_ip
    user     = "ec2-user"
    password = "DevOps321"


  }
  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install nginx -y",
      "sudo systemctl enable nginx",
      "exit 0"
    ]
    
    


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