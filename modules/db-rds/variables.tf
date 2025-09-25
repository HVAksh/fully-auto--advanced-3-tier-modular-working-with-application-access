variable "db_sub_1_id" {}
variable "db_sub_2_id" {}
variable "db_sg_id" {}
variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}