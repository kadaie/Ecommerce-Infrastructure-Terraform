output "rds_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.rds_instance.id
}

# Output the RDS Endpoint Address
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}
# Output the Subnet Group Name
output "rds_subnet_group_name" {
  description = "RDS subnet group name"
  value       = aws_db_subnet_group.rds_subnet_group.name
}
