# modules/ecs/outputs.tf

output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.ecommerce_cluster.id
}
output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecommerce_cluster.name
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.ecs-alb.dns_name
}
output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.ecs-alb.zone_id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.ecommerce_service.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "ecs_asg_arn" {
  description = "ARN of the ECS ASG"
  value       = aws_autoscaling_group.ecs-asg.arn
}

output "alb_listener_green_arn" {
  value = aws_lb_listener.green.arn
}

output "alb_listener_blue_arn" {
  value = aws_lb_listener.blue.arn
}
output "alb_tg_blue_name" {
  value = aws_lb_target_group.ecs-tg-blue.name
}
output "alb_tg_green_name" {
  value = aws_lb_target_group.ecs-tg-green.name
}
