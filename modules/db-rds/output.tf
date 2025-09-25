output "aurora_cluster_endpoint" {
  description = "The writer endpoint (primary)"
  value       = aws_rds_cluster.aurora-cluster.endpoint
}

output "aurora_reader_endpoint" {
  description = "The reader endpoint (read replicas)"
  value       = aws_rds_cluster.aurora-cluster.reader_endpoint
}
output "aurora_database_name" {
  value = aws_rds_cluster.aurora-cluster.database_name
}