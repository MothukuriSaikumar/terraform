
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
  #dynamic block
     dynamic "ingress" {
        for_each = toset(var.ingress_ports)

        content {
          from_port   = ingress.value
          to_port     = ingress.value
          protocol    = "tcp"
        }
     }
    tags = {    
    Name = "roboshop_sg"
}
}