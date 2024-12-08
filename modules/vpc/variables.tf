# modules/networking/variables.tf
variable "az-a" {
  description = "Availability Zone A"
}
variable "az-b" {
  description = "Availability Zone B"
}
variable "vpc_cidr" {}
variable "project_name" {}