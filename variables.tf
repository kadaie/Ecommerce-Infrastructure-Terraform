variable "az-a" {
  description = "Availability Zone A"
}
variable "az-b" {
  description = "Availability Zone B"
}
variable "vpc_cidr" {}
variable "project_name" {}
#ECS
variable "ecs_ami_id" {
  type = string
}
variable "ecs_instance_type" {
  type = string
}
variable "ecs_min_size" {
  type = number
}
variable "ecs_max_size" {
  type = number
}
variable "ecs_desired_capacity" {
  type = number
}
variable "rds_allocated_storage" {
  type = number
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
variable "rds_backup_retention" {}
variable "bucket_name" {}
#ECR 
variable "repository_name" {}
#cloudfront
variable "comment" {}
variable "container_name" {}
#CodePipeline
variable "container_port" {}

variable "dockerhub_username" {
}
variable "dockerhub_password" {

}