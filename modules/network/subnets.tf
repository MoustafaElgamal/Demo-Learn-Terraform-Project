resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone    = var.region_subnet_1_id
  map_public_ip_on_launch = "true"

    tags = {
     Name: "${var.env_prefix}-public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone    = var.region_subnet_2_id
  map_public_ip_on_launch = "true"

     tags = {
     Name: "${var.env_prefix}-public-subnet-2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id               = aws_vpc.myvpc.id
  cidr_block           = var.private_subnet_1_cidr
  availability_zone = var.region_subnet_1_id

    tags = {
     Name: "${var.env_prefix}-private-subnet-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id               = aws_vpc.myvpc.id
  cidr_block           = var.private_subnet_2_cidr
  availability_zone = var.region_subnet_2_id

    tags = {
     Name: "${var.env_prefix}-private-subnet-2"
  }
}