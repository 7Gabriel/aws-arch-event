output "private_subnet_ids" {
  description = "IDs das sub-redes privadas"
  value       = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "default_security_group_id" {
  value = aws_vpc.main.default_security_group_id
}
