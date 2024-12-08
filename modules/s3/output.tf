output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket.bucket
}
output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}
output "cp_s3_bucket_arn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
}
output "cp_s3_bucket_name" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
}