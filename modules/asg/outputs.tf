output "web_asg_name" {
  description = "Name of the Web Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "app_asg_name" {
  description = "Name of the App Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}