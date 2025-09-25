output "db_username" {
  value     = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).username
  sensitive = true
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
