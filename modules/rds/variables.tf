variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_engine" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_db_name" {
  type = string
}

variable "rds_master_username" {
  type = string
}

variable "rds_master_password" {
  type = string
}
variable "project_name" {
  type = string
}
variable "rds_backup_retention" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}
variable "rds_sg" {}