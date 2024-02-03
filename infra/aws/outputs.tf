output "vpc_id" {
  value = aws_vpc.m4-vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}