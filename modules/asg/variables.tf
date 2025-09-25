variable "project_name" {}
variable "env" {}
variable "web_sg_id" {}
variable "app_sg_id" {}
variable "ec2_profile_name" {}
variable "ec2_profile_arn" {}
variable "web_sub_1_id" {}
variable "app_sub_2_id" {}
variable "app_sub_1_id" {}
variable "web_sub_2_id" {}
variable "web_alb_tg_arn" {}
variable "app_alb_tg_arn" {}

variable "web_min_size" {}
variable "web_max_size" {}
variable "web_desired_capacity" {}

variable "app_min_size" {}
variable "app_max_size" {}
variable "app_desired_capacity" {}

variable "web_instance_type" {}
variable "app_instance_type" {}

variable "app_alb_dns_name" {}
variable "web_alb_dns_name" {}

variable "db_host" {}
variable "db_user" {}
variable "db_name" {}
variable "environment" {}
variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}
variable "web_tier_sns_arn" {
  description = "SNS topic ARN for web tier alerts"
  type        = string
}

variable "app_tier_sns_arn" {
  description = "SNS topic ARN for app tier alerts"
  type        = string
}
