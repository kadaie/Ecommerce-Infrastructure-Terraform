module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  az-a         = var.az-a
  az-b         = var.az-b
}
module "ecs" {
  source                  = "./modules/ecs"
  project_name            = var.project_name
  ecs_sg                  = module.sg.ecs_sg_id
  alb_sg                  = module.sg.alb_sg_id
  vpc_id                  = module.vpc.vpc_id
  container_image         = module.ecr.repository_url
  ecs_ami_id              = var.ecs_ami_id
  ecs_instance_type       = var.ecs_instance_type
  ecs_min_size            = var.ecs_min_size
  ecs_max_size            = var.ecs_max_size
  ecs_desired_capacity    = var.ecs_desired_capacity
  rds_allocated_storage   = var.rds_allocated_storage
  ecs_instance_profile    = module.iam.ecs_instance_profile
  private_subnet_1        = module.vpc.private_subnet_ids[0]
  private_subnet_2        = module.vpc.private_subnet_ids[1]
  security-group          = module.sg.ecs_sg_id
  container_name          = var.container_name
  private_subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  ecs_task_execution_role = module.iam.ecs_task_execution_role
}
module "rds" {
  source                = "./modules/rds"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_allocated_storage = var.rds_allocated_storage
  rds_engine            = var.rds_engine
  rds_engine_version    = var.rds_engine_version
  rds_instance_class    = var.rds_instance_class
  rds_db_name           = var.rds_db_name
  rds_master_username   = var.rds_master_username
  rds_master_password   = var.rds_master_password
  project_name          = var.project_name
  rds_sg                = module.sg.rds_sg_id
}
module "s3" {
  source       = "./modules/s3"
  bucket_name  = var.bucket_name
  project_name = var.project_name
}
module "ecr" {
  source          = "./modules/ecr"
  project_name    = var.project_name
  repository_name = var.repository_name
  scan_on_push    = false
}
module "cloudfront" {
  source             = "./modules/cloudfront"
  comment            = var.comment
  origin_domain_name = module.ecs.alb_dns_name
}
module "sg" {
  source       = "./modules/sg"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}
module "iam" {
  source           = "./modules/iam"
  cp_s3_bucket_arn = module.s3.cp_s3_bucket_arn
  project_name     = var.project_name
}
module "codepipeline" {
  source                  = "./modules/codepipeline"
  codebuild_role_arn      = module.iam.codebuild_role_arn
  codedeploy_role_arn     = module.iam.codedeploy_role_arn
  codepipeline_role_arn   = module.iam.codepipeline_role_arn
  dockerhub_username      = var.dockerhub_username
  dockerhub_password      = var.dockerhub_password
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_service_name        = module.ecs.service_name
  project_name            = var.project_name
  cp_s3_bucket_name       = module.s3.cp_s3_bucket_name
  ecr_repository_uri      = module.ecr.repository_url
  alb_listener_green_arn  = module.ecs.alb_listener_green_arn
  alb_listener_blue_arn   = module.ecs.alb_listener_blue_arn
  alb_tg_blue_name        = module.ecs.alb_tg_blue_name
  alb_tg_green_name       = module.ecs.alb_tg_green_name
  ecs_asg_arn             = module.ecs.ecs_asg_arn
  ecs_task_definition_arn = module.ecs.task_definition_arn
  container_name          = var.container_name
  container_port          = var.container_port
}