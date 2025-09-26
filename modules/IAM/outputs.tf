# global/IAM/output.tf
output "ec2_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2-profile.name
}

output "ec2_profile_arn" {
  description = "ARN of the EC2 instance profile (use if name doesn't work in your context)"
  value       = aws_iam_instance_profile.ec2-profile.arn
}

output "backup_role_arn" {
  description = "ARN of the IAM role for AWS Backup"
  value       = aws_iam_role.backup_role.arn
}

output "cloudtrail_to_cw_role_arn" {
  value = aws_iam_role.cloudtrail_to_cw.arn
}
output "flow_logs_role_arn" {
  value = aws_iam_role.flow_logs_role.arn
}
# output "restore_role_arn" {
#   description = "ARN of the IAM role for AWS Backup"
#   value       = aws_iam_role.restore_role.arn
# }