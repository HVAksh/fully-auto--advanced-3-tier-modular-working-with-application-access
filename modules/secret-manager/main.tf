resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!@#%^&*()-_=+[]{}"
  upper            = true
  lower            = true
  numeric           = true
  keepers = {
    # Forces regeneration if any of these values change
    regenerate_on_change = var.project_name
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}-db-credentials"
  description = "Database credentials for Aurora DB"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result  # Use the variable instead of hardcoding the password
  })
}
