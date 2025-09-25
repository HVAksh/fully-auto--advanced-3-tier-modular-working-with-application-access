output "primary_vault_arn" {
  value = aws_backup_vault.primary.arn
}
output "backup_web" {
  value = aws_backup_selection.backup_web.iam_role_arn
}
output "backup_app" {
  value = aws_backup_selection.backup_app.iam_role_arn
}