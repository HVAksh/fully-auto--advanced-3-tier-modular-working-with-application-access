output "web_alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}
output "web_alb_arn" {
  description = "ARN of the Web ALB"
  value       = aws_lb.web_alb.arn
}
output "web_tg_arn" {
  value = aws_lb_target_group.web_alb_tg.arn
}

output "app_alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
output "app_alb_arn" {
  description = "ARN of the Web ALB"
  value       = aws_lb.app_alb.arn
}
output "app_tg_arn" {
  value = aws_lb_target_group.app_alb_tg.arn
}
