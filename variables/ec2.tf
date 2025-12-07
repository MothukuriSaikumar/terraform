resource "aws_instance" "terraform1" {
  ami                    = var.ami_id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags                   = var.ec2_tags

}


resource "aws_security_group" "allow_all" {
  # ... other configuration ...
  name = var.ec2_sg

  egress {
    from_port   = var.sg_egress_from_port
    to_port     = var.sg_egress_to_port
    protocol    = var.sg_protocol
    cidr_blocks = var.sg_cidar_blocks

  }
  ingress {
    from_port = var.sg_ingress_from_port
    to_port   = var.sg_ingress_to_port
    protocol =  var.sg_protocol
    cidr_blocks = var.sg_cidar_blocks
  }
  tags = {
    Name = var.ec2_sg
  }
}
