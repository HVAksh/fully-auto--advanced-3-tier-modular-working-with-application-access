variable "project_name" {}
variable "env" {}
variable "region" {}
variable "vpc_cidr" {}

variable "pub_sub_1_cidr" {}
variable "pub_sub_2_cidr" {}
variable "web_sub_1_cidr" {}
variable "web_sub_2_cidr" {}
variable "app_sub_1_cidr" {}
variable "app_sub_2_cidr" {}
variable "db_sub_1_cidr" {}
variable "db_sub_2_cidr" {}
variable "web_instance_type" {}
variable "app_instance_type" {}
# variable "cross_region_resource_arns" {
#   type        = list(string)
#   description = "List of resource ARNs (backup vaults, KMS keys) used for cross-region backup copies"
# }
# variable "certificate_domain_name" {}
variable "domain_name" {}

variable "subject_alternative_name" {}
variable "web_desired_capacity" {}
variable "web_min_size" {}
variable "web_max_size" {}
variable "app_desired_capacity" {}
variable "app_min_size" {}
variable "app_max_size" {}
variable "alert_email" {

}
