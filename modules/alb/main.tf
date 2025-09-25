
###########################################################
#######         web LB (Internet Facing)          #########
###########################################################

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_alb_sg_id]
  subnets            = [var.pub_sub_1_id,var.pub_sub_2_id]

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-web-alb"
    Project     = var.project_name
    Environment = var.env
    Tier        = "web"
  }
}
resource "aws_lb_target_group" "web_alb_tg" {
  name     = "${var.project_name}-web-tg"
  target_type = "instance"              # this is default if not mentioned still fine
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"           #should be changed as per developer
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
  tags = {
    Name        = "${var.project_name}-web-tg"
    Project     = var.project_name
    Environment = var.env
    Tier        = "web"
  }
}
# create a listener on port 80 with redirect action
resource "aws_lb_listener" "web_http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}
###########################################################
##############        app LB          ################
###########################################################

resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.app_alb_sg_id]
  subnets            = [var.web_sub_1_id,var.web_sub_2_id]

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-app-alb"
    Project     = var.project_name
    Environment = var.env
    Tier        = "app"
  }
}
resource "aws_lb_target_group" "app_alb_tg" {
  name     = "${var.project_name}-app-tg"
  target_type = "instance"              # this is default if not mentioned still fine
  port     = 4000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"       #should be changed as per developer
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
  tags = {
    Name        = "${var.project_name}-app-tg"
    Project     = var.project_name
    Environment = var.env
    Tier        = "app"
  }
}
# create a listener on port 80 with redirect action
resource "aws_lb_listener" "app_http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_alb_tg.arn
  }
}

