output "web_tier_sns_arn" {
  value = aws_sns_topic.web_tier_sns.arn
}

output "app_tier_sns_arn" {
  value = aws_sns_topic.app_tier_sns.arn
}

output "cloudwatch_sns_arn" {
  value = aws_sns_topic.cloudwatch_sns.arn
}
