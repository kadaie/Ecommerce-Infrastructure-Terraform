variable "bucket_name" {
  description = "Bucket Name"
  type        = string
}
variable "project_name" {
  description = "Project Name"
  type        = string
}
variable "codepipeline_bucket_name" {
  default = "codepipeline-bucket-05"
}

