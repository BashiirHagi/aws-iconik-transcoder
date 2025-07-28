output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.iconik_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.iconik_public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.iconik_private_subnet.id
}