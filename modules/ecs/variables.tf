# modules/ecs/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "container_image" {
  description = "Container image to be used"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task"
  type        = number
  default     = 512
}

variable "service_desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 2
}

variable "health_check_path" {
  description = "Health check path for the default target group"
  type        = string
  default     = "/"
}
variable "ecs_ami_id" {}
variable "ecs_instance_type" {}
variable "ecs_min_size" {}
variable "ecs_max_size" {}
variable "ecs_desired_capacity" {}
variable "rds_allocated_storage" {}
variable "ecs_sg" {}
variable "alb_sg" {}
variable "ecs_instance_profile" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}
variable "security-group" {}
variable "container_name" {}
variable "ecs_task_execution_role" {}