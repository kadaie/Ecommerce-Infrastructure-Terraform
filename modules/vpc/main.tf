resource "aws_vpc" "lab-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "lab-public-subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.lab-vpc.id
  cidr_block              = count.index == 0 ? "10.1.0.0/24" : "10.1.1.0/24"
  availability_zone       = count.index == 0 ? var.az-a : var.az-b
  map_public_ip_on_launch = true # Make both subnets public

  tags = {
    Name = "Public-Subnet-${element(["ZA", "ZB"], count.index)}"
  }
}

# Create private subnets

resource "aws_subnet" "lab-private-subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.lab-vpc.id
  cidr_block              = count.index == 0 ? "10.1.2.0/24" : "10.1.3.0/24"
  availability_zone       = count.index == 0 ? var.az-a : var.az-b
  map_public_ip_on_launch = false # Make both subnets private

  tags = {
    Name = "Private-Subnet-${element(["ZA", "ZB"], count.index)}"
  }
}

resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-vpc.id
  tags = {
    Name = "${var.project_name}-IGW"
  }
}

# Create Elastic IPs for NAT gateways
resource "aws_eip" "lab_nat_eip" {
  tags = {
    Name = "NAT-GW_EIP"
  }
}

# Create NAT gateways in public subnets

resource "aws_nat_gateway" "lab_nat_gateway" {
  allocation_id = aws_eip.lab_nat_eip.id
  subnet_id     = aws_subnet.lab-public-subnets[0].id
  tags = {
    Name = "NAT-GW"
  }
}

# Create route table for private subnetss - NAT for internet access
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab_nat_gateway.id
  }
  tags = {
    Name = "Private-Route-Table"
  }

}

# Create route table for public subnets
resource "aws_route_table" "lab-public-route-table" {
  vpc_id = aws_vpc.lab-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-igw.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

# Associate private route table  with private subnets
resource "aws_route_table_association" "private_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.lab-private-subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate public route table with public subnets
resource "aws_route_table_association" "lab-public-subnet-nat-association" {
  count          = 2
  subnet_id      = aws_subnet.lab-public-subnets[count.index].id
  route_table_id = aws_route_table.lab-public-route-table.id
}