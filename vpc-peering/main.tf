resource "aws_vpc" "primary_vpc" {
  cidr_block           = var.primary_vpc_cidr
  provider             = aws.primary
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {

    Name    = "PrimaryVPC-${var.aws_primary_region}"
    purpose = "vpc-peering"

  }

}
resource "aws_vpc" "secondary_vpc" {
  cidr_block           = var.secondary_vpc_cidr
  provider             = aws.secondary
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {

    Name    = "SecondaryVPC-${var.aws_secondary_region}"
    purpose = "vpc-peering"

  }

}
resource "aws_subnet" "primary_subnet" {
  vpc_id     = aws_vpc.primary_vpc.id
  cidr_block = var.primary_subnet_cidrs
  provider   = aws.primary
  availability_zone = data.aws_availability_zones.primary_az.names[0]
  map_public_ip_on_launch = true

  tags = {

    Name    = "PrimarySubnet-${var.aws_primary_region}"
    purpose = "vpc-peering"

  }

}
resource "aws_subnet" "secondary_subnet" {
  vpc_id     = aws_vpc.secondary_vpc.id
  cidr_block = var.secondary_subnet_cidrs
  provider   = aws.secondary
  availability_zone = data.aws_availability_zones.secondary_az.names[0]
  map_public_ip_on_launch = true

  tags = {

    Name    = "SecondarySubnet-${var.aws_secondary_region}"
    purpose = "vpc-peering"

  }
}

resource "aws_internet_gateway" "primary_igw" {
  vpc_id   = aws_vpc.primary_vpc.id
  provider = aws.primary

  tags = {

    Name    = "PrimaryIGW-${var.aws_primary_region}"
    purpose = "vpc-peering"

  }
}

resource "aws_internet_gateway" "secondary_igw" {
  vpc_id   = aws_vpc.secondary_vpc.id
  provider = aws.secondary

  tags = {

    Name    = "SecondaryIGW-${var.aws_secondary_region}"
    purpose = "vpc-peering"

  }
}

resource "aws_route_table" "primary_route_table" {
  vpc_id = aws_vpc.primary_vpc.id
  provider = aws.primary

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }
}
resource "aws_route_table" "secondary_route_table" {
  vpc_id = aws_vpc.secondary_vpc.id
  provider = aws.secondary

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }
}
resource "aws_route_table_association" "primary_route_table_association" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_route_table.id
}
resource "aws_route_table_association" "secondary_route_table_association" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_route_table.id
}

# VPC Peering Connection request from primary to secondary VPC
resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondary_vpc.id
  peer_region = var.aws_secondary_region
  auto_accept = false

  
  tags = {
    Name = "PrimaryToSecondaryVPCPeering"
    side = "requester"
  }
}

# VPC Peering Connection accept from secondary to primary VPC
resource "aws_vpc_peering_connection_accepter" "secondary_to_primary" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true
  tags = {
    Name = "SecondaryToPrimaryVPCPeering"
    side = "accepter"
  }
}
resource "aws_route" "primary_to_secondary_route" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_route_table.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  
 
}

resource "aws_route" "secondary_to_primary_route" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_route_table.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  
  
}

resource "aws_security_group" "primary-instance-sg" {
  name        = "primary-instance-sg"
  description = "Security group for primary instance"
  vpc_id      = aws_vpc.primary_vpc.id
  provider   = aws.primary

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "primary-instance-sg"
  }
}

resource "aws_security_group" "secondary-instance-sg" {
  name        = "secondary-instance-sg"
  description = "Security group for secondary instance"
  vpc_id      = aws_vpc.secondary_vpc.id
  provider   = aws.secondary

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "secondary-instance-sg"
  }
}
# EC2 instance in primary VPC
resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary-ami.id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  key_name               = var.primary_access_key
  vpc_security_group_ids = [aws_security_group.primary-instance-sg.id]

  tags = {
    Name = "PrimaryInstance"
  }
}
# EC2 instance in secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondary-ami.id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.secondary_subnet.id
  key_name               = var.secondary_access_key
  vpc_security_group_ids = [aws_security_group.secondary-instance-sg.id]

  tags = {
    Name = "SecondaryInstance"
  }
}
