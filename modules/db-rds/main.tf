#✅ Create Aurora MySQL DB Subnet Group
resource "aws_db_subnet_group" "aurora-db-subnet-group" {
  name       = "aurora-subnet-group"
  subnet_ids = [var.db_sub_1_id, var.db_sub_2_id]

  tags = {
    Name = "project1-Aurora-Db-Subnet-Group"
  }
}

# ✅ Create Aurora MySQL Cluster (Primary)
resource "aws_rds_cluster" "aurora-cluster" {
  cluster_identifier      = "project1-aurora-mysql-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.04.0" # Use latest supported version
  database_name           = "auroradb"
  master_username         = "admin"
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.aurora-db-subnet-group.name
  vpc_security_group_ids  = [var.db_sg_id]
  backup_retention_period = 7 # Keep backups for 7 days
  preferred_backup_window = "07:00-09:00"
  apply_immediately       = true
  storage_encrypted       = true
  
  # ✅ Set to true in production

  # ✅ Prevent Terraform from requiring a final snapshot, else make it false, true only for test case
  skip_final_snapshot       = true
  final_snapshot_identifier = "aurora-cluster-final-snapshot"

  tags = {
    Name = "project1-Aurora-MySQL-Cluster"
  }

}

# ✅ Create Aurora MySQL Primary Instance
resource "aws_rds_cluster_instance" "aurora-primary" {
  identifier          = "project1-aurora-primary"
  cluster_identifier  = aws_rds_cluster.aurora-cluster.id
  instance_class      = "db.r6g.large" # Choose an instance type suitable for Aurora
  engine              = "aurora-mysql"
  publicly_accessible = false
  apply_immediately   = true

  tags = {
    Name = "project1-Aurora-Primary"
  }
}

# ✅ Create Aurora MySQL Read Replica
resource "aws_rds_cluster_instance" "aurora_read_replica" {
  identifier          = "aurora-read-replica"
  cluster_identifier  = aws_rds_cluster.aurora-cluster.id
  instance_class      = "db.r6g.large"
  engine              = "aurora-mysql"
  publicly_accessible = false
  apply_immediately   = true

  tags = {
    Name = "project1-Aurora-Read-Replica"
  }
}

