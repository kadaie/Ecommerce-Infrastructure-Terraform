variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "git_full_repo_id" {
  default = "kadaie/Ecommerce-Laravel"
}
variable "git_branch_name" {
  default = "main"
}
variable "dockerhub_username" {
}
variable "dockerhub_password" {

}
variable "ecs_asg_arn" {}
variable "alb_listener_blue_arn" {}
variable "alb_listener_green_arn" {}
variable "alb_tg_blue_name" {}
variable "alb_tg_green_name" {}
variable "ecr_repository_uri" {}
variable "container_name" {}
variable "container_port" {}
variable "ecs_task_definition_arn" {}
variable "codebuild_role_arn" {}
variable "codedeploy_role_arn" {}
variable "codepipeline_role_arn" {}
variable "cp_s3_bucket_name" {}
variable "project_name" {}
