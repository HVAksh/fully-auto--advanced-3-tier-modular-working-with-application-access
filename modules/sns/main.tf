#################################
# WEB SNS Topic and Subscription
#################################

resource "aws_sns_topic" "web_tier_sns" {
  name = "web-tier-sns"
  tags = {
    Tier    = "web"
    Purpose = "web tier alerts"
  }
}

resource "aws_sns_topic_subscription" "web_tier_email" {
  topic_arn = aws_sns_topic.web_tier_sns.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

#################################
# APP SNS Topic and Subscription
#################################

resource "aws_sns_topic" "app_tier_sns" {
  name = "app-tier-sns"

  tags = {
    Tier    = "app"
    Purpose = "app tier alerts"
  }
}

resource "aws_sns_topic_subscription" "app_tier_email" {
  topic_arn = aws_sns_topic.app_tier_sns.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

#################################
# DB SNS Topic and Subscription
#################################

resource "aws_sns_topic" "cloudwatch_sns" {
  name = "cloudwatch-sns"

  tags = {
    Tier    = "monitoring"
    Purpose = "CloudWatch alerts"
  }
}

resource "aws_sns_topic_subscription" "cloudwatch_email" {
  topic_arn = aws_sns_topic.cloudwatch_sns.arn
  protocol  = "email"
  endpoint  = var.alert_email
}