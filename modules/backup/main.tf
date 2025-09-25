# modules/backup/main.tf
resource "aws_backup_vault" "primary" {
  name = "primary-vault"
}

resource "aws_backup_plan" "plan" {
  name = "backup-plan"

  rule {
    rule_name         = "daily"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 30
    }

  }
}

resource "aws_backup_selection" "backup_web" {
  iam_role_arn = var.backup_role_arn  #"arn:aws:iam::account:role/backup-role"  # From IAM
  name         = "web-backup"
  plan_id      = aws_backup_plan.plan.id

  resources = ["arn:aws:ec2:*:*:instance/*"]  # Tag based or specific for web
}

resource "aws_backup_selection" "backup_app" {
  iam_role_arn = var.backup_role_arn #"arn:aws:iam::account:role/backup-role"  # From IAM
  name         = "app-backup"
  plan_id      = aws_backup_plan.plan.id

  resources = ["arn:aws:ec2:*:*:instance/*"]  # Or use selection_tag for tag-based
  # Example tag-based selection (better for dynamic resources like ASGs)
  # selection_tag {
  #   type  = "STRINGEQUALS"
  #   key   = "Backup"
  #   value = "Yes"
  # }
}