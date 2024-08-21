# Get value of id from private subnet resource
locals{
  public_subnet_id = [for env in aws_subnet.public: env.id]
} 

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "ig_crud" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-ig"
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
}

# NAT
resource "aws_nat_gateway" "nat_crud" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = tolist(local.public_subnet_id)[0]

  tags = {
    Name = "${var.environment}-nat"
  }
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  for_each                = var.public_subnet
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
    tags = {
    Name = "${var.environment}-${each.key}"
  }
}

# Private subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  for_each                = var.private_subnet
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
    tags = {
    Name = "${var.environment}-${each.key}"
  }
}

# Private RDS-subnet
resource "aws_subnet" "private_rds" {
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  for_each                = var.private_subnet_RDS
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
    tags = {
    Name = "${var.environment}-${each.key}"
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id                  = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-private-route-table"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id                  = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-public-route-table"
  }
}

# Routing tables to route traffic for Private RDS Subnet
resource "aws_route_table" "private_RDS_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-private-route-table-RDS"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig_crud.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_crud.id
#  gateway_id             = aws_internet_gateway.ig_crud.id
}

resource "aws_route_table_association" "public" {
  route_table_id         = aws_route_table.public.id 
  for_each               = aws_subnet.public
  subnet_id              = each.value.id
}

resource "aws_route_table_association" "private" {
  route_table_id         = aws_route_table.private.id 
  for_each               = aws_subnet.private
  subnet_id              = each.value.id
}

resource "aws_route_table_association" "privateRDS" {
  route_table_id         = aws_route_table.private_RDS_subnet.id 
  for_each               = aws_subnet.private_rds
  subnet_id              = each.value.id
}
