data "aws_region" "current" {}
resource "aws_codestarconnections_connection" "codestarconnections" {
  name          = "github-connection"
  provider_type = "GitHub"
}
resource "aws_codebuild_project" "codebuild_project" {
  name         = "${var.project_name}-emommerce-build"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "AWS_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.ecr_repository_uri
    }
    environment_variable {
      name  = "ECS_TASK_DEFINITION_ARN"
      value = var.ecs_task_definition_arn
    }
    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = var.dockerhub_username
    }
    environment_variable {
      name  = "DOCKERHUB_PASS"
      value = var.dockerhub_password
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}

resource "aws_codedeploy_app" "codedeploy_app" {
  name             = "${var.project_name}-ecommerce-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "${var.project_name}-ecommerce-deployment-gp"
  service_role_arn      = var.codedeploy_role_arn

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }
  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }
  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }
  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.alb_tg_blue_name
      }
      target_group {
        name = var.alb_tg_green_name
      }

      prod_traffic_route {
        listener_arns = [var.alb_listener_blue_arn]
      }
      test_traffic_route {
        listener_arns = [var.alb_listener_green_arn]
      }
    }
  }
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project_name}-ecommerce-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.cp_s3_bucket_name
    type     = "S3"

    # encryption_key {
    #   id   = data.aws_kms_alias.s3kmskey.arn
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestarconnections.arn
        FullRepositoryId = var.git_full_repo_id
        BranchName       = var.git_branch_name
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["build_output"]
      # input_artifacts = ["source_output"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.codedeploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.codedeploy_deployment_group.deployment_group_name
      }
    }
  }
}