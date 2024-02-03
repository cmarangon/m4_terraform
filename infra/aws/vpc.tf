// VPC
resource "aws_vpc" "m4-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

// Read available zones
data "aws_availability_zones" "available" {}

// Subnets
resource "aws_subnet" "subnets" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.m4-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-subnet-${count.index}"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "m4-igw" {
  vpc_id = aws_vpc.m4-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

// Route Table
resource "aws_route_table" "m4-rtb" {
  vpc_id = aws_vpc.m4-vpc.id
  route {
    cidr_block = "0.0.0.0/0" // all can access
    gateway_id = aws_internet_gateway.m4-igw.id
  }
  tags = {
    Name = "${var.prefix}-rtb"
  }
}

// Route Table Associations
resource "aws_route_table_association" "m4-rtb-association" {
  count = 2
  route_table_id = aws_route_table.m4-rtb.id
  subnet_id = aws_subnet.subnets.*.id[count.index]
}

// Security Group
resource "aws_security_group" "m4-security-group" {
 name   = "ecs-security-group"
 vpc_id = aws_vpc.m4-vpc.id

 ingress {
   from_port = 0
   to_port = 0
   protocol = -1
   self = "false"
   cidr_blocks = ["0.0.0.0/0"]
   description = "any"
 }

 egress {
   from_port = 0 // all ports
   to_port = 0 // all ports
   protocol = "-1" // all protocols
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
  Name = "${var.prefix}-sg"
 }
}