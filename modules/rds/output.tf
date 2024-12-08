output "rds_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.rds_instance.id
}

# Output the RDS Endpoint Address
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}

# Output the RDS Security Group ID
output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}

# Output the Subnet Group Name
output "rds_subnet_group_name" {
  description = "RDS subnet group name"
  value       = aws_db_subnet_group.rds_subnet_group.name
}
