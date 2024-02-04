provider "aws" {
  region = "us-east-1"  
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a" 

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = "ami-079db87dc4c10ac91"  
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example_subnet.id

  tags = {
    Name = "terraform-instance"
  }
}
