output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}
output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}
output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}
output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}
output "ecs_task_execution_role" {
  value = aws_iam_role.ecs_task_execution_role.arn
}