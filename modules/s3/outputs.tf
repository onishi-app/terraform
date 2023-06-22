output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "バケットのID"
}
output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "バケットのARN"
}