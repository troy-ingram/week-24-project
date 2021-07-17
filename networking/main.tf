# --- networking/main.tf ---

resource "random_integer" "random" {
  min = 1
  max = 1000
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"][count.index]

  tags = {
    Name = "public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public"
  }
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow all inbound HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}