# modules/cloudfront/outputs.tf
output "distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.distribution.arn
}

output "domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}