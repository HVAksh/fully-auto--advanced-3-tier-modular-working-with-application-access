###########################################################
##############             WEB             ################
###########################################################

resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.project_name}-web-lt"
  image_id      = file("${path.module}/ami_ids/frontend_ami.txt")
  instance_type = var.web_instance_type
  vpc_security_group_ids = [var.web_sg_id]
  
  user_data              = base64encode(templatefile("${path.module}/web_user_data.sh", {
    project_name = var.project_name
    app_alb_dns  = var.app_alb_dns_name  # Make sure this is correct
    environment  = var.env
  }))
  
  # key_name      = var.key_name        # Use key name instead iam_instance_profile as per need
  iam_instance_profile {
    name = var.ec2_profile_name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-web"
      Project     = var.project_name
      Environment = var.env
      Tier        = "web"
    }
  }
  # depends_on = [ module.alb ]
}

resource "aws_autoscaling_group" "web_asg" {

  name                = "${var.project_name}-web-asg"
  min_size            = var.web_min_size
  max_size            = var.web_max_size
  desired_capacity    = var.web_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [var.web_sub_1_id, var.web_sub_2_id]
  target_group_arns = [var.web_alb_tg_arn]

    enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = aws_launch_template.web_lt.latest_version
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web-scale-up-policy" {
  name                   = "web-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}
resource "aws_cloudwatch_metric_alarm" "web-scale-up-alarm" {
  alarm_name          = "web-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [
    aws_autoscaling_policy.web-scale-down-policy.arn,
    var.web_tier_sns_arn
  ]
    ok_actions = [
    var.web_tier_sns_arn
  ]
  insufficient_data_actions = [
    var.web_tier_sns_arn
  ]
}

resource "aws_autoscaling_policy" "web-scale-down-policy" {
  name                   = "web-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}
resource "aws_cloudwatch_metric_alarm" "web-scale-down-alarm" {
  alarm_name          = "web-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [
    aws_autoscaling_policy.web-scale-down-policy.arn,
    var.web_tier_sns_arn
  ]
    ok_actions = [
    var.web_tier_sns_arn
  ]
  insufficient_data_actions = [
    var.web_tier_sns_arn
  ]
}


###########################################################
##############             APP             ################
###########################################################

resource "aws_launch_template" "app_lt" {
  name   = "app_lt"
  image_id      = file("${path.module}/ami_ids/backend_ami.txt")
  instance_type = var.app_instance_type
  vpc_security_group_ids = [var.app_sg_id]
  user_data = base64encode(templatefile("${path.module}/app_user_data.sh", {
    project_name = var.project_name
    project_name = var.project_name
    db_host      = var.db_host
    db_user      = var.db_user
    db_password  = var.db_password
    db_name      = var.db_name
    environment  = var.env
  }))
  
  iam_instance_profile {
    name = var.ec2_profile_name
  }

  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-app"
      Project     = var.project_name
      Environment = var.env
      Tier        = "app"
    }
  }
  # depends_on = [ module.db-rds, module.secret-manager ]
}

resource "aws_autoscaling_group" "app_asg" {

  name                      = "${var.project_name}-app-asg"
  min_size                  = var.app_min_size
  max_size                  = var.app_max_size
  desired_capacity          = var.app_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [var.app_sub_1_id, var.app_sub_2_id]
  target_group_arns = [var.app_alb_tg_arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = aws_launch_template.app_lt.latest_version
  }
    tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
  }

  # depends_on = [ module.db-rds.outputs.aurora_cluster_endpoint ]

}

resource "aws_autoscaling_policy" "app-scale-up-policy" {
  name                   = "app-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}
resource "aws_cloudwatch_metric_alarm" "app-scale-up-alarm" {
  alarm_name          = "app-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [
    aws_autoscaling_policy.app-scale-down-policy.arn,
    var.app_tier_sns_arn
  ]
    ok_actions = [
    var.app_tier_sns_arn
  ]
  insufficient_data_actions = [
    var.app_tier_sns_arn
  ]
}

resource "aws_autoscaling_policy" "app-scale-down-policy" {
  name                   = "app-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}
resource "aws_cloudwatch_metric_alarm" "app-scale-down-alarm" {
  alarm_name          = "app-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [
    aws_autoscaling_policy.app-scale-down-policy.arn,
    var.app_tier_sns_arn
  ]
    ok_actions = [
    var.app_tier_sns_arn
  ]
  insufficient_data_actions = [
    var.app_tier_sns_arn
  ]

}