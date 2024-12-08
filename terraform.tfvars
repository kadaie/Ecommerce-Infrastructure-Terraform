az-a         = "us-east-1a"
az-b         = "us-east-1b"
vpc_cidr     = "10.1.0.0/16"
project_name = "test"
#ECS
ecs_ami_id           = "ami-0021619f6563c0914"
ecs_instance_type    = "t3.medium"
ecs_min_size         = 1
ecs_max_size         = 3
ecs_desired_capacity = 2
container_name       = "ecommerce-container"
container_port       = 80
# RDS instance configuration
rds_engine            = "mysql"
rds_engine_version    = "8.0.39"
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
rds_master_username   = "user01"
rds_master_password   = "securepassword123"
rds_db_name           = "mydatabase"
rds_backup_retention  = 7
bucket_name           = "ecommerce-data-04"
repository_name       = "ecommerce-repo"
comment               = "CloudFront Distribution"
dockerhub_username    = "kadaie2212"
dockerhub_password    = "Docker*$2233"


