# modules/networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.lab-vpc.id
}

output "vpc-igw" {
  value = aws_internet_gateway.lab-igw
}
output "public_subnet_ids" {
  value = aws_subnet.lab-public-subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.lab-private-subnets[*].id
}