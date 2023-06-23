output "sg_id" {
  value       = aws_security_group.this.id
  description = "セキュリティグループのID"
}
output "sg_name" {
  value       = aws_security_group.this.name
  description = "セキュリティグループ名"
}