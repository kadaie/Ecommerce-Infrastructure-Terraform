# modules/ecs/main.tf
# ECS Cluster
resource "aws_ecs_cluster" "ecommerce_cluster" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}
# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.project_name}-ecs-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs-asg.arn
    # managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}
resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecommerce_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 1
    base              = 1
  }
}
# ECS Launch Template
resource "aws_launch_template" "ecs_launch_template" {
  name          = "${var.project_name}-ecs-launch-template"
  image_id      = var.ecs_ami_id
  instance_type = var.ecs_instance_type

  iam_instance_profile {
    name = var.ecs_instance_profile
  }

  vpc_security_group_ids = [var.ecs_sg]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.ecommerce_cluster.name} >> /etc/ecs/ecs.config
    EOF
  )
}
# ECS ASG
resource "aws_autoscaling_group" "ecs-asg" {
  name                      = "${var.project_name}-ecs-asg"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
}
# Application Load Balancer
resource "aws_lb" "ecs-alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnet_ids
  tags = {
    Name = "${var.project_name}-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "ecs-tg-blue" {
  name        = "${var.project_name}-tg-blue"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    matcher             = "200-299"
  }

  tags = {
    Name = "${var.project_name}-tg-blue"
  }
}
resource "aws_lb_target_group" "ecs-tg-green" {
  name        = "${var.project_name}-tg-green"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    matcher             = "200-299"
  }

  tags = {
    Name = "${var.project_name}-tg-green"
  }
  depends_on = [
    aws_ecs_service.ecommerce_service
  ]
}
# ALB Listeners
resource "aws_lb_listener" "blue" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg-blue.arn
  }
}
resource "aws_lb_listener" "green" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg-green.arn
  }
}

# ECS Service
resource "aws_ecs_service" "ecommerce_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.ecommerce_cluster.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.service_desired_count


  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = [var.private_subnet_1, var.private_subnet_2]
    security_groups = [var.security-group]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-tg-blue.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = {
    Name = "${var.project_name}-service"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_task_execution_role

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.task_cpu
      memory    = var.task_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "us-east-1"
        }
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-task"
  }
}
